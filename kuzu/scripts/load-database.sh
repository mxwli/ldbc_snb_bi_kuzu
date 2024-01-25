
set -eu
set -o pipefail

source setup-venv.sh

./clear-database.sh

loadTable() { # usage: loadTable <tablename> <tabletype> <loc>
	python3 load-table.py $1 $2 ../schemas/${3}.txt $(find ${KUZU_CSV_DIR}/initial_snapshot/${3} -type f -name *.csv)
}

# nodes
loadTable Place NODE static/Place
loadTable Organisation NODE static/Organisation
loadTable TagClass NODE static/TagClass
loadTable Tag NODE static/Tag
loadTable Forum NODE dynamic/Forum
loadTable Person NODE dynamic/Person
loadTable Comment NODE dynamic/Comment
loadTable Post NODE dynamic/Post

# rels
loadTable IS_PART_OF REL static/Place_isPartOf_Place
loadTable IS_SUBCLASS_OF REL static/TagClass_isSubclassOf_TagClass
loadTable ORGANISATION_IS_LOCATED_IN REL static/Organisation_isLocatedIn_Place
loadTable HAS_TYPE REL static/Tag_hasType_TagClass
loadTable COMMENT_HAS_CREATOR REL dynamic/Comment_hasCreator_Person
loadTable COMMENT_IS_LOCATED_IN REL dynamic/Comment_isLocatedIn_Country
loadTable REPLY_OF_COMMENT REL dynamic/Comment_replyOf_Comment
loadTable REPLY_OF_POST REL dynamic/Comment_replyOf_Post
loadTable CONTAINER_OF REL dynamic/Forum_containerOf_Post
loadTable HAS_MEMBER REL dynamic/Forum_hasMember_Person
loadTable HAS_MODERATOR REL dynamic/Forum_hasModerator_Person
loadTable FORUM_HAS_TAG REL dynamic/Forum_hasTag_Tag
loadTable HAS_INTEREST REL dynamic/Person_hasInterest_Tag
loadTable PERSON_IS_LOCATED_IN REL dynamic/Person_isLocatedIn_City
loadTable KNOWS REL dynamic/Person_knows_Person
loadTable LIKES_COMMENT REL dynamic/Person_likes_Comment
loadTable LIKES_POST REL dynamic/Person_likes_Post
loadTable POST_HAS_CREATOR REL dynamic/Post_hasCreator_Person
loadTable COMMENT_HAS_TAG REL dynamic/Comment_hasTag_Tag
loadTable POST_HAS_TAG REL dynamic/Post_hasTag_Tag
loadTable POST_IS_LOCATED_IN REL dynamic/Post_isLocatedIn_Country
loadTable STUDY_AT REL dynamic/Person_studyAt_University
loadTable WORK_AT REL dynamic/Person_workAt_Company

