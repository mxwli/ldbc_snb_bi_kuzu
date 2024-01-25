
set -eu
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

source scripts/setup-venv.sh

scripts/clear-database.sh

start=`date +%s`

python3 scripts/load-schema.py

loadTable() { # usage: loadTable <tablename> <tabletype> <loc>
	python3 scripts/load-table.py $1 $2 $(find ${KUZU_CSV_DIR}/initial_snapshot/${3} -type f -name *.csv)
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
loadTable IS_LOCATED_IN_Organisation_Place REL static/Organisation_isLocatedIn_Place
loadTable HAS_TYPE REL static/Tag_hasType_TagClass
loadTable HAS_CREATOR_Comment_Person REL dynamic/Comment_hasCreator_Person
loadTable IS_LOCATED_IN_Comment_Place REL dynamic/Comment_isLocatedIn_Country
loadTable REPLY_OF_Comment_Comment REL dynamic/Comment_replyOf_Comment
loadTable REPLY_OF_Comment_Post REL dynamic/Comment_replyOf_Post
loadTable CONTAINER_OF REL dynamic/Forum_containerOf_Post
loadTable HAS_MEMBER REL dynamic/Forum_hasMember_Person
loadTable HAS_MODERATOR REL dynamic/Forum_hasModerator_Person
loadTable HAS_TAG_Forum_Tag REL dynamic/Forum_hasTag_Tag
loadTable HAS_INTEREST REL dynamic/Person_hasInterest_Tag
loadTable IS_LOCATED_IN_Person_Place REL dynamic/Person_isLocatedIn_City
loadTable KNOWS REL dynamic/Person_knows_Person
loadTable LIKES_Person_Comment REL dynamic/Person_likes_Comment
loadTable LIKES_Person_Post REL dynamic/Person_likes_Post
loadTable HAS_CREATOR_Post_Person REL dynamic/Post_hasCreator_Person
loadTable HAS_TAG_Comment_Tag REL dynamic/Comment_hasTag_Tag
loadTable HAS_TAG_Post_Tag REL dynamic/Post_hasTag_Tag
loadTable IS_LOCATED_IN_Post_Place REL dynamic/Post_isLocatedIn_Country
loadTable STUDY_AT REL dynamic/Person_studyAt_University
loadTable WORK_AT REL dynamic/Person_workAt_Company

end=`date +%s`
echo Execution time was `expr $end - $start` seconds.
