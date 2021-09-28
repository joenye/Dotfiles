#!/usr/bin/env bash
# set -e
shopt -s dotglob

# Run from the project root
# Ensure solution has already been assembled

# # Copy packages from components/ into main/packages/
for c in components/* ; do
	COMPONENT=$(basename "$c")
	for p in components/"$COMPONENT"/packages/* ; do
		PACKAGE=$(basename "$p")
		RENAMED_PACKAGE="${COMPONENT}-${PACKAGE}"
		TARGET_DIR=main/packages
		echo "Copying $p -> $TARGET_DIR/$RENAMED_PACKAGE"
		cp -r "$p" main/packages/"$RENAMED_PACKAGE"
	done
done

# # Remove components directory
rm -rf components/

# Remove assembly packages
rm -rf main/packages/*assembly*

# Move into src
mkdir -p src/plugin-registries
mv main/api-integration-tests src/
mv main/.generated-solution src/deployable-units
mv main/packages/registry-* src/plugin-registries
mv main/packages/main-commands src/plugin-registries/registry-commands

# Move config
mv main/config .

# Move into lib
mkdir -p lib
mv main/packages/* lib/

# Remove main directory
rm -rf main

# Move config/settings to settings/
mkdir -p settings
mv config/settings/* settings
rmdir config

# Uninstall submodules and remove component metadata
rm buildspec-components.yml
rm component.yml
rm .gitmodules
rm -rf .git/modules
git config --local -l | grep submodule | sed -e 's/^\(submodule\.[^.]*\)\(.*\)/\1/g' | while read -r line; do (git config --local --remove-section "$line"); done

# Edit serverless.yml and replace line
sed -i "s|  settings: \${file(./main/config/settings/.settings.js):merged}|  settings: \${file(./settings/.settings.js):merged}|" serverless.yml

# Clear lockfile and re-generate
rm pnpm-lock.yaml

# Rewrite pnpm-workspace.yaml
tee pnpm-workspace.yaml << END
packages:
  - src/deployable-units/*
  - src/deployable-units/cicd/*
  - src/deployable-units/docs/dist-autogen
  - src/plugin-registries/*
  - lib/*
END

# Remove unused assembly/main-* imports
sed -i '/base-assembly-tasks/d' src/deployable-units/edge-lambda/package.json
sed -i '/main-assembly/d' package.json
sed -i '/main-assembly/d' lib/base-serverless-solution-commands/package.json
sed -i '/main-controllers/d' src/deployable-units/backend/package.json
sed -i '/main-services/d' src/deployable-units/backend/package.json
sed -i '/main-services/d' src/deployable-units/post-deployment/package.json
sed -i '/main-ui/d' src/deployable-units/ui/package.json

# Remove remaining "main-*" packages
rm -rf lib/main-*

# Remove remaining "main-*" packages from plugin registries
sed -i '/main-controllers/d' src/plugin-registries/registry-backend/package.json
sed -i '/main-services/d' src/plugin-registries/registry-backend/package.json
sed -i '/main-services/d' src/plugin-registries/registry-post-deployment/package.json
sed -i '/main-ui/d' src/plugin-registries/registry-ui/package.json
sed -i '/main-controllers/d' src/plugin-registries/registry-backend/lib/api-handler/plugin-registry.js
sed -i '/main-services/d' src/plugin-registries/registry-backend/lib/api-handler/plugin-registry.js
sed -i '/controllersPlugin/d' src/plugin-registries/registry-backend/lib/api-handler/plugin-registry.js
sed -i '/servicesPlugin,/d' src/plugin-registries/registry-backend/lib/api-handler/plugin-registry.js
sed -i '/fileSchemasPlugin/d' src/plugin-registries/registry-backend/lib/api-handler/plugin-registry.js
sed -i '/main-services/d' src/plugin-registries/registry-backend/lib/dataset-batch-processing-handler/plugin-registry.js
sed -i '/fileSchemasPlugin/d' src/plugin-registries/registry-backend/lib/dataset-batch-processing-handler/plugin-registry.js
sed -i '/main-services/d' src/plugin-registries/registry-backend/lib/dataset-solution-bus-handler/plugin-registry.js
sed -i '/fileSchemasPlugin/d' src/plugin-registries/registry-backend/lib/dataset-solution-bus-handler/plugin-registry.js
sed -i '/main-services/d' src/plugin-registries/registry-backend/lib/workflow-loop-runner/plugin-registry.js
sed -i '/servicesPlugin,/d' src/plugin-registries/registry-backend/lib/workflow-loop-runner/plugin-registry.js
sed -i '/fileSchemasPlugin/d' src/plugin-registries/registry-backend/lib/workflow-loop-runner/plugin-registry.js
sed -i 's/, usersPlugin]/]/g' src/plugin-registries/registry-post-deployment/lib/plugin-registry.js
sed -i '/main-services/d' src/plugin-registries/registry-post-deployment/lib/plugin-registry.js
sed -i '/main-ui/d' src/plugin-registries/registry-ui/lib/plugin-registry.js
sed -i 's/appContextItemsPlugin,//g' src/plugin-registries/registry-ui/lib/plugin-registry.js
sed -i 's/, initializationPlugin]/]/g' src/plugin-registries/registry-ui/lib/plugin-registry.js
sed -i 's/menuItemsPlugin,//g' src/plugin-registries/registry-ui/lib/plugin-registry.js
sed -i 's/routesPlugin,//g' src/plugin-registries/registry-ui/lib/plugin-registry.js

# Remove componentsDir naming
sed -i '/@param componentsDir/d' src/plugin-registries/registry-commands/lib/plugin-registry.js
sed -i 's/componentsDir, //g' src/plugin-registries/registry-commands/lib/plugin-registry.js
sed -i 's/componentsDir, //g' src/plugin-registries/registry-commands/lib/index.js
sed -i '/componentsDir/d' src/plugin-registries/registry-commands/lib/index.js
sed -i 's|main/.generated-solution|src/deployable-units|' src/plugin-registries/registry-commands/lib/index.js
sed -i '/main-ui/d' src/deployable-units/ui/src/index.js

# Update paths to settings files in each DU
sed -i 's|../../../../config/settings|../../../../../settings|' src/deployable-units/backend/config/settings/.settings.js
sed -i 's|../../../../config/settings|../../../../../settings|' src/deployable-units/custom-domains/config/settings/.settings.js
sed -i 's|../../../../config/settings|../../../../../settings|' src/deployable-units/docs/config/settings/.settings.js
sed -i 's|../../../../config/settings|../../../../../settings|' src/deployable-units/edge-lambda/config/settings/.settings.js
sed -i 's|../../../../config/settings|../../../../../settings|' src/deployable-units/environment-tools/config/settings/.settings.js
sed -i 's|../../../../config/settings|../../../../../settings|' src/deployable-units/eventbridge-infra/config/settings/.settings.js
sed -i 's|../../../../config/settings|../../../../../settings|' src/deployable-units/post-deployment/config/settings/.settings.js
sed -i 's|../../../../config/settings|../../../../../settings|' src/deployable-units/ui/config/settings/.settings.js
sed -i 's|../../../../config/settings|../../../../../settings|' src/deployable-units/web-infra/config/settings/.settings.js
sed -i 's|../../../../../config/settings|../../../../../../settings|' src/deployable-units/cicd/cicd-pipeline/config/settings/.settings.js
sed -i 's|../../../../../config/settings|../../../../../../settings|' src/deployable-units/cicd/cicd-target/config/settings/.settings.js

# Remove docs dist-autogen (willl be re-generated on solution-build)
rm -rf src/deployable-units/docs/dist-autogen

# Remove main-assembl

# Re-install packages
pnpm i
rm -rf node_modules

# TODO: Remove all assemble lines from base-serverless-solution-commandss
sed -i '6d;64,70d;90,168d' lib/base-serverless-solution-commands/lib/serverless-solution-commands.js
sed -i '/main-assembly/d' lib/base-serverless-solution-commands/lib/serverless-solution-commands.js
sed -i 's|'\''lint'\'', \[|'\''lint'\'');|' lib/base-serverless-solution-commands/lib/serverless-solution-commands.js
sed -i '35,53d;129d;178,180d' lib/base-serverless-solution-commands/lib/serverless-solution-commands-plugin.js

# Ensure files are all formatted properly with Prettier
1npm run format:prettier -r

# Strip unnecessary "registry-" prefix from plugin-registries/*
# TODO

# Update hardcoded paths to old settings files
sed -i 's|../../config/settings|../../settings|' src/deployable-units/post-deployment/serverless.yml
sed -i 's|../../../components|../../../lib|' src/deployable-units/post-deployment/serverless.yml
sed -i 's|digital-investigation-msab/packages||' src/deployable-units/post-deployment/serverless.yml
sed -i 's|digital-investigation-xways/packages||' src/deployable-units/post-deployment/serverless.yml
sed -i 's|digital-investigation-cellebrite/packages||' src/deployable-units/post-deployment/serverless.yml
sed -i 's|digital-investigation-griffeye/packages||' src/deployable-units/post-deployment/serverless.yml

# TODO: Move file-schemas-plugin into DI component (previously in main-services)
