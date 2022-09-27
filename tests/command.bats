#!/usr/bin/env bats

setup() {
    load "$BATS_PLUGIN_PATH/load.bash"

    # Uncomment to enable stub debugging
    # export GIT_STUB_DEBUG=/dev/tty
}

@test "Testing a test: bats works AOK" {
    echo "AOK - this worked"
    assert_success
}

@test "Markdown Spellchecker" {
    export BUILDKITE_PLUGIN_SHELLCHECK_FILES_0="tests/testdata/test.md"

    stub docker \
        "run --rm -v $PWD:/mnt --workdir /mnt tmaier/markdown-spellcheck:latest --report "**/*.md" : echo spellcheck Markdown"

    run "$PWD/hooks/command"

    assert_success
    assert_output --partial "spell check done"
    assert_output --partial "Annotation added"
    unstub buildkite-agent
    unstub docker
}
