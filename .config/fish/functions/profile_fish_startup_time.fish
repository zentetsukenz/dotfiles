function profile_fish_startup_time --description 'Profile fish_prompt function and see which command is slow'
    fish --profile prompt.prof -ic 'fish_prompt; exit'; sort -nk 2 prompt.prof ; rm prompt.prof
end
