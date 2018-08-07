Text Object Nouns

iw : inner word (Works anywhere in a word)
it : inner tag (Contents of <> tags)
i" : inner quotes (Refers to next inner quotes)
ip : inner paragraph (Refers to group of lines)
as : sentence

Surround:

> Old text                  Command     New text ~
>   "Hello *world!"           ds"         Hello world!
>   [123+4*56]/2              cs])        (123+456)/2
>   "Look ma, I'm *HTML!"     cs"<q>      <q>Look ma, I'm HTML!</q>
>   if *x>3 {                 ysW(        if ( x>3 ) {
>   my $str = *whee!;         vllllS'     my $str = 'whee!';
