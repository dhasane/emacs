
for file in ./repos/*; do
    echo "$file" && cd "$file" && git reset --hard && cd -
done
