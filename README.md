# Git Cron Jobs BASH Shell Scripts

Automatic git taks for cron.

## Settings

$ nano local.conf

    CommitPath="/path/Commits"
    InfoDir="/path/.info"
    ServerName="Hostname"
    RepoPath=/home/git/repositories/
    Receiver="eMail"
    ! One empty row only at the end of this file !


## Files

### GitCommit.sh

Get a overview from all commits from every repository that are hosted on the server.


### GitGarbageCollection.sh

Garbage collection for all empty objects references from repository.


### GitStats.sh

Check Git Server Stats and send it via mail to an user.


## License

[GNU GPL Version 3](http://www.gnu.org/copyleft/gpl.html)