#!/usr/bin/env bats

load test_helper

# `show` ######################################################################

@test "'show' with no argument exits with status 1 and prints help." {
  {
    "${_NB}" init
    "${_NB}" add

    _files=($(ls "${NB_DIR}/home/")) && _filename="${_files[0]}"
  }

  run "${_NB}" show

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 1              ]]
  [[ "${lines[0]}" =~ Usage\:     ]]
  [[ "${lines[1]}" =~ '  nb show' ]]
}

@test "'show' with no argument does not show the note file." {
  skip "TODO: Determine how to test for '\$PAGER'."
  {
    "${_NB}" init
    "${_NB}" add

    _files=($(ls "${NB_DIR}/home/")) && _filename="${_files[0]}"
  }

  run "${_NB}" show

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
}

# `show --dump` ###############################################################

@test "'show --dump' with argument exits with 0 and prints note with highlighting." {
  {
    "${_NB}" init
    "${_NB}" add "# Example"

    _files=($(ls "${NB_DIR}/home/")) && _filename="${_files[0]}"
  }

  run "${_NB}" show 1 --dump

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 0                ]]
  [[ ! "${lines[0]}" == "# Example" ]]
  [[ "${lines[0]}" =~ "Example"     ]]
}

@test "'show --dump --no-color' with argument exits with 0 and prints note without highlighting." {
  {
    "${_NB}" init
    "${_NB}" add "# Example"

    _files=($(ls "${NB_DIR}/home/")) && _filename="${_files[0]}"
  }

  run "${_NB}" show 1 --dump --no-color

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 0              ]]
  [[ "${lines[0]}" =~ "# Example" ]]
}

@test "'show --dump' with no argument exits with 1 and prints help." {
  {
    "${_NB}" init
    "${_NB}" add "# Example"

    _files=($(ls "${NB_DIR}/home/")) && _filename="${_files[0]}"
  }

  run "${_NB}" show --dump

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 1              ]]
  [[ ! "${output}" =~ mock_editor ]]
  [[ "${lines[0]}" =~ Usage\:     ]]
  [[ "${lines[1]}" =~ '  nb show' ]]
}

# <selector> ##################################################################

@test "'show <selector>' with empty repo exits with 1 and prints help." {
  {
    "${_NB}" init
  }

  run "${_NB}" show 1

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 1                                                      ]]
  [[ "${lines[0]}" == "${_ERROR_PREFIX} Not found: $(_color_primary "1")" ]]
}

# `show <filename> --dump` ####################################################

@test "'show <filename> --dump' exits with status 0 and dumps note file." {
  {
    "${_NB}" init
    "${_NB}" add

    _files=($(ls "${NB_DIR}/home/")) && _filename="${_files[0]}"
  }

  run "${_NB}" show "${_filename}" --dump

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 0            ]]
  [[ "${output}" =~ mock_editor ]]
}

# `show <id> --dump` ##########################################################

@test "'show <id> --dump' exits with status 0 and dumps note file." {
  {
    "${_NB}" init
    "${_NB}" add

    _files=($(ls "${NB_DIR}/home/")) && _filename="${_files[0]}"
  }

  run "${_NB}" show 1 --dump

  printf "\${_filename}: %s\\n" "${_filename}"
  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 0            ]]
  [[ "${output}" =~ mock_editor ]]
}

# `show <path> --dump` #######################################################

@test "'show <path> --dump' exits with status 0 and dumps note file." {
  {
    "${_NB}" init
    "${_NB}" add

    _files=($(ls "${NB_DIR}/home/")) && _filename="${_files[0]}"
  }

  run "${_NB}" show "${NB_DIR}/home/${_filename}" --dump

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 0            ]]
  [[ "${output}" =~ mock_editor ]]
}

# `show <title> --dump` #######################################################

@test "'show <title> --dump' exits with status 0 and dumps note file." {
  {
    "${_NB}" init
    "${_NB}" add --title "Example Title"

    _files=($(ls "${NB_DIR}/home/")) && _filename="${_files[0]}"
  }
  _title="$(head -1 "${NB_DIR}/home/${_filename}" | sed 's/^\# //')"

  run "${_NB}" show "${_title}" --dump

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 0                ]]
  [[ "${output}" =~ Example\ Title  ]]
}

# `show <filename> --path` ####################################################

@test "'show <filename> --path' exits with status 0 and prints note path." {
  {
    "${_NB}" init
    "${_NB}" add

    _files=($(ls "${NB_DIR}/home/")) && _filename="${_files[0]}"
  }

  run "${_NB}" show "${_filename}" --path

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 0                              ]]
  [[ "${output}" == "${NB_DIR}/home/${_filename}" ]]
}

# `show <id> --path` ##########################################################

@test "'show <id> --path' exits with status 0 and prints note path." {
  {
    "${_NB}" init
    "${_NB}" add

    _files=($(ls "${NB_DIR}/home/")) && _filename="${_files[0]}"
  }

  run "${_NB}" show 1 --path

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 0                              ]]
  [[ "${output}" == "${NB_DIR}/home/${_filename}" ]]
}

# `show <path> --path` #######################################################

@test "'show <path> --path' exits with status 0 and prints note path." {
  {
    "${_NB}" init
    "${_NB}" add

    _files=($(ls "${NB_DIR}/home/")) && _filename="${_files[0]}"
  }

  run "${_NB}" show "${NB_DIR}/home/${_filename}" --path

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 0                              ]]
  [[ "${output}" == "${NB_DIR}/home/${_filename}" ]]
}

# `show <title> --path` #######################################################

@test "'show <title> --path' exits with status 0 and prints note path." {
  {
    "${_NB}" init
    "${_NB}" add --title "Example Title"

    _files=($(ls "${NB_DIR}/home/")) && _filename="${_files[0]}"
    _title="$(head -1 "${NB_DIR}/home/${_filename}" | sed 's/^\# //')"
  }

  run "${_NB}" show "${_title}" --path

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 0                                  ]]
  [[ "${output}" == "${NB_DIR}/home/${_filename}"  ]]
}

# `show <filename> --id` ######################################################

@test "'show <filename> --id' exits with status 0 and prints note id." {
  {
    "${_NB}" init
    "${_NB}" add

    _files=($(ls "${NB_DIR}/home/")) && _filename="${_files[0]}"
  }

  run "${_NB}" show "${_filename}" --id

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 0    ]]
  [[ "${output}" == "1" ]]
}

# `show <id> --id` ############################################################

@test "'show <id> --id' exits with status 0 and prints note id." {
  {
    "${_NB}" init
    "${_NB}" add

    _files=($(ls "${NB_DIR}/home/")) && _filename="${_files[0]}"
  }

  run "${_NB}" show 1 --id

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 0    ]]
  [[ "${output}" == "1" ]]
}

# `show <path> --id` ##########################################################

@test "'show <path> --id' exits with status 0 and prints note id." {
  {
    "${_NB}" init
    "${_NB}" add

    _files=($(ls "${NB_DIR}/home/")) && _filename="${_files[0]}"
  }

  run "${_NB}" show "${NB_DIR}/home/${_filename}" --id

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 0    ]]
  [[ "${output}" == "1" ]]
}

# `show <title> --id` #########################################################

@test "'show <title> --id' exits with status 0 and prints note id." {
  {
    "${_NB}" init
    "${_NB}" add

    _files=($(ls "${NB_DIR}/home/")) && _filename="${_files[0]}"
    _title="$(head -1 "${NB_DIR}/home/${_filename}" | sed 's/^\# //')"
  }

  run "${_NB}" show "${NB_DIR}/home/${_filename}" --id

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 0    ]]
  [[ "${output}" == "1" ]]
}

# encrypted ###################################################################

@test "'show' with encrypted file show properly without errors." {
  {
    "${_NB}" init
    "${_NB}" add "# Content" --encrypt --password=example

    _files=($(ls "${NB_DIR}/home/")) && _filename="${_files[0]}"
  }

  run "${_NB}" show 1 --password=example --dump

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  # Returns status 0
  [[ ${status} -eq 0 ]]

  # Prints file content
  [[ "${output}" =~ Content ]]
}

# `show <id> --filename` ######################################################

@test "'show <id> --filename' exits with status 0 and prints note filename." {
  {
    "${_NB}" init
    "${_NB}" add "example.md"

    _files=($(ls "${NB_DIR}/home/")) && _filename="${_files[0]}"
  }

  run "${_NB}" show 1 --filename

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 0              ]]
  [[ "${output}" == "example.md"  ]]
}

@test "'show <id> --basename' exits with status 0 and prints note filename." {
  {
    "${_NB}" init
    "${_NB}" add "example.md"

    _files=($(ls "${NB_DIR}/home/")) && _filename="${_files[0]}"
  }

  run "${_NB}" show 1 --basename

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 0              ]]
  [[ "${output}" == "example.md"  ]]
}

# `show <id> --title` #########################################################

@test "'show <id> --title' exits with status 0 and prints note filename." {
  {
    "${_NB}" init
    "${_NB}" add "example.md" --title "Example Title"

    _files=($(ls "${NB_DIR}/home/")) && _filename="${_files[0]}"
  }

  run "${_NB}" show 1 --title

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 0                ]]
  [[ "${output}" == "Example Title" ]]
}

# `show <id> --indicators` ####################################################

@test "'show <id> --indicators' exits with status 0 and prints bookmark indicator." {
  {
    "${_NB}" init
    "${_NB}" add "example.bookmark.md" --content "<https://example.test>"

    _files=($(ls "${NB_DIR}/home/")) && _filename="${_files[0]}"
  }

  run "${_NB}" show 1 --indicators

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status}      -eq 0 ]]
  [[ "${output}"    =~ 🔖 ]]
  [[ ! "${output}"  =~ 🔒 ]]
}

@test "'show <id> --indicators' exits with status 0 and prints encrypted indicator." {
  {
    "${_NB}" init
    "${_NB}" add "example.md" --encrypt --password=password

    _files=($(ls "${NB_DIR}/home/")) && _filename="${_files[0]}"
  }

  run "${_NB}" show 1 --indicators

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status}      -eq 0 ]]
  [[ ! "${output}"  =~ 🔖 ]]
  [[ "${output}"    =~ 🔒 ]]
}

@test "'show <id> --indicators' exits with status 0 and prints encrypted bookmark indicators." {
  {
    "${_NB}" init
    "${_NB}" add "example.bookmark.md"    \
      --content "<https://example.test>"  \
      --encrypt --password=password

    _files=($(ls "${NB_DIR}/home/")) && _filename="${_files[0]}"
  }

  run "${_NB}" show 1 --indicators

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status}      -eq 0 ]]
  [[ "${output}"    =~ 🔖 ]]
  [[ "${output}"    =~ 🔒 ]]
}

# `show <id> --added` #########################################################

@test "'show <id> --added' exits with status 0 and prints the added timestamp." {
  {
    "${_NB}" init
    "${_NB}" add "example.md" --title "Example Title"

    _files=($(ls "${NB_DIR}/home/")) && _filename="${_files[0]}"
  }

  run "${_NB}" show 1 --added

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 0                  ]]
  [[ "${output}" =~ [0-9]{4}-[0-9]{2} ]]
}

@test "'show <id> -a' exits with status 0 and prints the added timestamp." {
  {
    "${_NB}" init
    "${_NB}" add "example.md" --title "Example Title"

    _files=($(ls "${NB_DIR}/home/")) && _filename="${_files[0]}"
  }

  run "${_NB}" show 1 -a

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 0                  ]]
  [[ "${output}" =~ [0-9]{4}-[0-9]{2} ]]
}

# `show <id> --updated` #######################################################

@test "'show <id> --updated' exits with status 0 and prints the updated timestamp." {
  {
    "${_NB}" init
    "${_NB}" add "example.md" --title "Example Title"

    _added="$("${_NB}" show 1 --added)"

    run "${_NB}" show 1 --added

    [[ "${output}" == "${_added}"  ]]

    sleep 1

    "${_NB}" edit 1 --content "More content."

    _files=($(ls "${NB_DIR}/home/")) && _filename="${_files[0]}"
  }

  run "${_NB}" show 1 --updated

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  printf "\${_added}: '%s'\\n" "${_added}"

  [[ ${status} -eq 0                  ]]
  [[ "${output}" =~ [0-9]{4}-[0-9]{2} ]]
  [[ "${output}" != "${_added}"       ]]
}

@test "'show <id> -u' exits with status 0 and prints the updated timestamp." {
  {
    "${_NB}" init
    "${_NB}" add "example.md" --title "Example Title"

    _added="$("${_NB}" show 1 --added)"

    run "${_NB}" show 1 --added

    [[ "${output}" == "${_added}"  ]]

    sleep 1

    "${_NB}" edit 1 --content "More content."

    _files=($(ls "${NB_DIR}/home/")) && _filename="${_files[0]}"
  }

  run "${_NB}" show 1 -u

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  printf "\${_added}: '%s'\\n" "${_added}"

  [[ ${status} -eq 0                  ]]
  [[ "${output}" =~ [0-9]{4}-[0-9]{2} ]]
  [[ "${output}" != "${_added}"       ]]
}

# `show <id> --selector-id` ###################################################

@test "'show <id> --selector-id' exits with status 0 and prints the selector id." {
  {
    "${_NB}" init
  }

  run "${_NB}" show 42 --selector-id

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 0    ]]
  [[ "${output}" =~ 42  ]]
}

@test "'show <id> --selector-id' exits with status 0 and prints the selector id without notebook." {
  {
    "${_NB}" init
  }

  run "${_NB}" show notebook:42 --selector-id

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 0    ]]
  [[ "${output}" =~ 42  ]]
}

@test "'show <id> --selector-id' exits with status 0 and prints the selector filename." {
  {
    "${_NB}" init
  }

  run "${_NB}" show example.md --selector-id

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 0            ]]
  [[ "${output}" =~ example.md  ]]
}

@test "'show <id> --selector-id' exits with status 0 and prints the selector filename without notebook." {
  {
    "${_NB}" init
  }

  run "${_NB}" show notebook:example.md --selector-id

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 0            ]]
  [[ "${output}" =~ example.md  ]]
}

@test "'show <id> --selector-id' exits with status 0 and prints the selector title." {
  {
    "${_NB}" init
  }

  run "${_NB}" show Example\ Title --selector-id

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 0                ]]
  [[ "${output}" =~ Example\ Title  ]]
}

@test "'show <id> --selector-id' exits with status 0 and prints the selector title without notebook." {
  {
    "${_NB}" init
  }

  run "${_NB}" show notebook:Example\ Title --selector-id

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 0                ]]
  [[ "${output}" =~ Example\ Title  ]]
}

@test "'show <id> --selector-id' exits with status 0 and prints the selector path." {
  {
    "${_NB}" init
  }

  run "${_NB}" show /example/path --selector-id

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 0                ]]
  [[ "${output}" =~ \/example\/path ]]
}

@test "'show <id> --selector-id' exits with status 0 and prints the selector path without notebook." {
  {
    "${_NB}" init
  }

  run "${_NB}" show notebook:/example/path --selector-id

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 0                ]]
  [[ "${output}" =~ \/example\/path ]]
}

@test "'show <id> --selector-id' exits with status 0 and prints nothing when blank with notebook." {
  {
    "${_NB}" init
  }

  run "${_NB}" show notebook: --selector-id

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 0  ]]
  [[ -z "${output:-}" ]]
}

# `show <id> --type` ##########################################################

@test "'show <id> --type' with note exits with status 0 and prints note type." {
  {
    "${_NB}" init
    "${_NB}" add

    _files=($(ls "${NB_DIR}/home/")) && _filename="${_files[0]}"
  }

  run "${_NB}" show 1 --type

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 0      ]]
  [[ "${output}" == "md"  ]]
}

@test "'show <id> --type' with bookmark exits with status 0 and prints note type." {
  {
    "${_NB}" init
    "${_NB}" bookmark "${_BOOKMARK_URL}"

    _files=($(ls "${NB_DIR}/home/")) && _filename="${_files[0]}"
  }

  run "${_NB}" show 1 --type

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 0      ]]
  [[ "${output}" == "bookmark.md"  ]]
}

@test "'show <id> --type <extension>' exits with status 0 when note matches." {
  {
    "${_NB}" init
    "${_NB}" add

    _files=($(ls "${NB_DIR}/home/")) && _filename="${_files[0]}"
  }

  run "${_NB}" show 1 --type md

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 0  ]]
  [[ -z "${output}"   ]]
}

@test "'show <id> --type <extension>' exits with status 0 when bookmark matches." {
  {
    "${_NB}" init
    "${_NB}" bookmark "${_BOOKMARK_URL}"

    _files=($(ls "${NB_DIR}/home/")) && _filename="${_files[0]}"
  }

  run "${_NB}" show 1 --type bookmark.md

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 0  ]]
  [[ -z "${output}"   ]]
}

@test "'show <id> --type <extension>' exits with status 0 when bookmark matches one level." {
  {
    "${_NB}" init
    "${_NB}" add

    _files=($(ls "${NB_DIR}/home/")) && _filename="${_files[0]}"
  }

  run "${_NB}" show 1 --type md

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 0  ]]
  [[ -z "${output}"   ]]
}

@test "'show <id> --type <type>' exits with status 0 when note matches." {
  {
    "${_NB}" init
    "${_NB}" add

    _files=($(ls "${NB_DIR}/home/")) && _filename="${_files[0]}"
  }

  run "${_NB}" show 1 --type text

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 0  ]]
  [[ -z "${output}"   ]]
}

@test "'show <id> --type <type>' exits with status 0 when bookmark matches." {
  {
    "${_NB}" init
    "${_NB}" bookmark "${_BOOKMARK_URL}"

    _files=($(ls "${NB_DIR}/home/")) && _filename="${_files[0]}"
  }

  run "${_NB}" show 1 --type bookmark

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 0  ]]
  [[ -z "${output}"   ]]
}

@test "'show <id> --type <type>' exits with status 1 when no type match." {
  {
    "${_NB}" init
    "${_NB}" add

    _files=($(ls "${NB_DIR}/home/")) && _filename="${_files[0]}"
  }

  run "${_NB}" show 1 --type not-valid

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 1  ]]
  [[ -z "${output}"   ]]
}

# `show <notebook>` ###########################################################

@test "'show <notebook>' exits with status 0 and runs ls in the notebook." {
  {
    "${_NB}" init
    "${_NB}" add "home-one.md"
    "${_NB}" add "home-two.md"
    "${_NB}" notebooks add example
    "${_NB}" example:add "example-one.md"
    "${_NB}" example:add "example-two.md"
  }

  run "${_NB}" show example

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ "${status}" -eq 0            ]]
  [[ "${lines[0]}" =~ example     ]]
  [[ "${lines[0]}" =~ home        ]]
  [[ "${lines[1]}" =~ ----        ]]
  [[ "${lines[2]}" =~ example-two ]]
  [[ "${lines[3]}" =~ example-one ]]
}

@test "'show <notebook>:' (with colon) exits with status 0 and runs ls in the notebook." {
  {
    "${_NB}" init
    "${_NB}" add "home-one.md"
    "${_NB}" add "home-two.md"
    "${_NB}" notebooks add example
    "${_NB}" example:add "example-one.md"
    "${_NB}" example:add "example-two.md"
  }

  run "${_NB}" show example:

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ "${status}" -eq 0            ]]
  [[ "${lines[0]}" =~ example     ]]
  [[ "${lines[0]}" =~ home        ]]
  [[ "${lines[1]}" =~ ----        ]]
  [[ "${lines[2]}" =~ example-two ]]
  [[ "${lines[3]}" =~ example-one ]]
}

@test "'show <notebook> --sort' exits with status 0 and runs ls in the notebook." {
  {
    "${_NB}" init
    "${_NB}" add "home-one.md"
    "${_NB}" add "home-two.md"
    "${_NB}" notebooks add example
    "${_NB}" example:add "example-one.md"
    "${_NB}" example:add "example-two.md"
  }

  run "${_NB}" show example --sort

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ "${status}" -eq 0            ]]
  [[ "${lines[0]}" =~ example-one ]]
  [[ "${lines[1]}" =~ example-two ]]
}

# `s <id>` #################################################################

@test "'s <id> --filename' exits with status 0 and prints note filename." {
  {
    "${_NB}" init
    "${_NB}" add "example.md"

    _files=($(ls "${NB_DIR}/home/")) && _filename="${_files[0]}"
  }

  run "${_NB}" s 1 --filename

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 0              ]]
  [[ "${output}" == "example.md"  ]]
}

# `view <id>` #################################################################

@test "'view <id> --filename' exits with status 0 and prints note filename." {
  {
    "${_NB}" init
    "${_NB}" add "example.md"

    _files=($(ls "${NB_DIR}/home/")) && _filename="${_files[0]}"
  }

  run "${_NB}" view 1 --filename

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 0              ]]
  [[ "${output}" == "example.md"  ]]
}

# `<id> show` alternative  ####################################################

@test "'<id> show --filename' exits with status 0 and prints note filename." {
  {
    "${_NB}" init
    "${_NB}" add "example.md"

    _files=($(ls "${NB_DIR}/home/")) && _filename="${_files[0]}"
  }

  run "${_NB}" 1 show --filename

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 0              ]]
  [[ "${output}" == "example.md"  ]]
}

# `<scoped>`  #################################################################

@test "'show <scope>:<id> --filename' exits with status 0 and prints note filename." {
  {
    "${_NB}" init
    "${_NB}" notebooks add "one"
    "${_NB}" one:add "example.md"

    _files=($(ls "${NB_DIR}/home/")) && _filename="${_files[0]}"

    [[ -e "${NB_DIR}/one/example.md"  ]]
  }

  run "${_NB}" show one:example.md --filename

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 0              ]]
  [[ "${output}" == "example.md"  ]]
}

@test "'<scope>:<id> show --filename' exits with status 0 and prints note filename." {
  {
    "${_NB}" init
    "${_NB}" notebooks add "one"
    "${_NB}" one:add "example.md"

    _files=($(ls "${NB_DIR}/home/")) && _filename="${_files[0]}"

    [[ -e "${NB_DIR}/one/example.md"  ]]
  }

  run "${_NB}" one:example.md show --filename

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 0              ]]
  [[ "${output}" == "example.md"  ]]
}

@test "'<scoped>:show <id> --filename' exits with status 0 and prints note filename." {
  {
    "${_NB}" init
    "${_NB}" notebooks add "one"
    "${_NB}" one:add "example.md"

    _files=($(ls "${NB_DIR}/home/")) && _filename="${_files[0]}"

    [[ -e "${NB_DIR}/one/example.md"  ]]
  }

  run "${_NB}" one:show example.md --filename

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 0              ]]
  [[ "${output}" == "example.md"  ]]
}

@test "'<id> <scoped>:show --filename' exits with status 0 and prints note filename." {
  {
    "${_NB}" init
    "${_NB}" notebooks add "one"
    "${_NB}" one:add "example.md"

    _files=($(ls "${NB_DIR}/home/")) && _filename="${_files[0]}"

    [[ -e "${NB_DIR}/one/example.md"  ]]
  }

  run "${_NB}" example.md one:show --filename

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 0              ]]
  [[ "${output}" == "example.md"  ]]
}

# `show <selector>` (notebook name) ###########################################

@test "'show <selector> --filename' with <selector> matching notebook name and note prints filename." {
  {
    "${_NB}" init
    "${_NB}" add "example.md" --title "example"
    "${_NB}" notebooks add "example"

    _files=($(ls "${NB_DIR}/home/")) && _filename="${_files[0]}"
  }

  run "${_NB}" show example --filename

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 0              ]]
  [[ "${output}" == "example.md"  ]]
}

@test "'show <selector> --filename' with <selector> only matching notebook name prints message." {
  {
    "${_NB}" init
    "${_NB}" add "sample.md" --title "sample"
    "${_NB}" notebooks add "example"

    _files=($(ls "${NB_DIR}/home/")) && _filename="${_files[0]}"
  }

  run "${_NB}" show example --filename

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 1                ]]
  [[ "${output:-}" =~ Not\ found\:  ]]
}

@test "'show <selector> --path' with <selector> matching notebook name and note prints path." {
  {
    "${_NB}" init
    "${_NB}" add "example.md" --title "example"
    "${_NB}" notebooks add "example"

    _files=($(ls "${NB_DIR}/home/")) && _filename="${_files[0]}"
  }

  run "${_NB}" show example --path

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 0                            ]]
  [[ "${output}" == "${NB_DIR}/home/example.md" ]]
}

@test "'show <selector> --path' with <selector> only matching notebook name prints message." {
  {
    "${_NB}" init
    "${_NB}" add "sample.md" --title "sample"
    "${_NB}" notebooks add "example"

    _files=($(ls "${NB_DIR}/home/")) && _filename="${_files[0]}"
  }

  run "${_NB}" show example --path

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 1                ]]
  [[ "${output:-}" =~ Not\ found\:  ]]
}

@test "'show <selector> --id' with <selector> matching notebook name and note prints id." {
  {
    "${_NB}" init
    "${_NB}" add "example.md" --title "example"
    "${_NB}" notebooks add "example"

    _files=($(ls "${NB_DIR}/home/")) && _filename="${_files[0]}"
  }

  run "${_NB}" show example.md --id

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 0    ]]
  [[ "${output}" == "1" ]]
}

@test "'show <selector> --id' with <selector> only matching notebook name prints message." {
  {
    "${_NB}" init
    "${_NB}" add "sample.md" --title "sample"
    "${_NB}" notebooks add "example"

    _files=($(ls "${NB_DIR}/home/")) && _filename="${_files[0]}"
  }

  run "${_NB}" show example --id

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 1                ]]
  [[ "${output:-}" =~ Not\ found\:  ]]
}

@test "'show <selector> --title' with <selector> matching notebook name and note prints title." {
  {
    "${_NB}" init
    "${_NB}" add "example.md" --title "example"
    "${_NB}" notebooks add "example"

    _files=($(ls "${NB_DIR}/home/")) && _filename="${_files[0]}"
  }

  run "${_NB}" show example --title

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 0          ]]
  [[ "${output}" == "example" ]]
}

@test "'show <selector> --title' with <selector> only matching notebook name prints message." {
  {
    "${_NB}" init
    "${_NB}" add "sample.md" --title "sample"
    "${_NB}" notebooks add "example"

    _files=($(ls "${NB_DIR}/home/")) && _filename="${_files[0]}"
  }

  run "${_NB}" show example --title

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 1                ]]
  [[ "${output:-}" =~ Not\ found\:  ]]
}

@test "'show <selector> --selector-id' with <selector> matching notebook name and note prints selector-id." {
  {
    "${_NB}" init
    "${_NB}" add "example.md" --title "example"
    "${_NB}" notebooks add "example"

    _files=($(ls "${NB_DIR}/home/")) && _filename="${_files[0]}"
  }

  run "${_NB}" show example --selector-id

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 0          ]]
  [[ "${output}" == "example" ]]
}

@test "'show <selector> --selector-id' with <selector> only matching notebook name prints selector id." {
  {
    "${_NB}" init
    "${_NB}" add "sample.md" --title "sample"
    "${_NB}" notebooks add "example"

    _files=($(ls "${NB_DIR}/home/")) && _filename="${_files[0]}"
  }

  run "${_NB}" show example --selector-id

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 0          ]]
  [[ "${output}" == "example" ]]
}

# help ########################################################################

@test "'help show' exits with status 0." {
  run "${_NB}" help show

  [[ ${status} -eq 0 ]]
}

@test "'help show' prints help information." {
  run "${_NB}" help show

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ "${lines[0]}" =~ Usage\:     ]]
  [[ "${lines[1]}" =~ '  nb show' ]]
}
