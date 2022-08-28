#! bin/sh

# build URL
buildUrl=`xmllint chromatic-build-*.xml --xpath "//property[@name='buildUrl']/@value" | sed -e "s/ value=\"\([^\"]*\)\"/\1/g"`

# storybook URL
storybookUrl=`xmllint chromatic-build-*.xml --xpath "//property[@name='storybookUrl']/@value" | sed -e "s/ value=\"\([^\"]*\)\"/\1/g"`

# test results
tests=`xmllint chromatic-build-*.xml --xpath "//testsuite/@tests" | sed -e "s/tests=\"\([^\"]*\)\"/\1/g"`
failures=`xmllint chromatic-build-*.xml --xpath "//testsuite/@failures" | sed -e "s/failures=\"\([^\"]*\)\"/\1/g"`
errors=`xmllint chromatic-build-*.xml --xpath "//testsuite/@errors" | sed -e "s/errors=\"\([^\"]*\)\"/\1/g"`
skipped=`xmllint chromatic-build-*.xml --xpath "//testsuite/@skipped" | sed -e "s/skipped=\"\([^\"]*\)\"/\1/g"`

# failures
count=1
failureCases=''
while :
do
	name=`xmllint chromatic-build-*.xml --xpath "//testcase[${count}]/failure"`
	if [ "${name}" != "" ]; then
		failureCases+=`xmllint chromatic-build-*.xml --xpath "//testcase[${count}]/@classname" | sed -e "s| classname=\"\([^\"]*\)\"|- \1/|g"`
		failureCases+=`xmllint chromatic-build-*.xml --xpath "//testcase[${count}]/@name" | sed -e "s/ name=\"\([^\"]*\)\"/\1/g"`
		failureCases+='\n'
	fi

	count=`expr ${count} + 1`

	if [  ${count} -gt ${tests} ]; then
    	break
  	fi
done

# Results
echo "<${storybookUrl}>" > result.md
echo "<sub>Build URL: ${buildUrl}</sub>" >> result.md
echo "<sub>(:fire: updated at $(date))</sub>" >> result.md
echo ":orange_circle: failures: ${failures} \t :red_circle: errors: ${errors} \t :large_blue_circle: skipped: ${skipped}" >> result.md

if [ "${failureCases}" != "" ]; then
	echo "### :orange_circle: Failures" >> result.md
	echo ${failureCases} >> result.md
else
	echo "### :green_circle: No changes!" >> result.md
fi
