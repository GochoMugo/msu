#
# tests against lib/metadata.sh
#


@test "metadata contains version & contact information" {
  source lib/metadata.sh
  [ ${MSU_AUTHOR_NAME} ]
  [ ${MSU_AUTHOR_EMAIL} ]
  [ ${MSU_VERSION} ]
}
