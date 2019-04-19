function groad --description 'Git reset every commit author date starts with current time plus one sec for every commit'
    command git filter-branch -f --env-filter 'GIT_AUTHOR_DATE=`date +%s`' --msg-filter 'sleep 1 && cat' $argv..HEAD
end
