function groad --description 'Git reset commit author dates to now with 1-second spacing'
    set -l base $argv[1]
    if test -z "$base"
        echo "Usage: groad <commit-ref>"
        echo "Example: groad HEAD~5"
        return 1
    end
    GIT_SEQUENCE_EDITOR=: command git rebase --exec 'git commit --amend --no-edit --date=now' -i $base
end
