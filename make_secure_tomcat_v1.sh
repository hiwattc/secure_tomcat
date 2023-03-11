#2023.03.11

################## EVN VAR #################
VERSION=9.0.24
#VERSION=9.0.73
FILENAME=apache-tomcat-$VERSION.tar.gz
DIRNAME=apache-tomcat-$VERSION

################## CHECK BEFORE(download file) #################
if [ -f "$FILENAME" ] ; then
echo "file exist, Deleting..."
rm -f ./$FILENAME
else
echo "file not exist. continues..."
fi
################## CHECK BEFORE(folder)  #################
if [ -d "$DIRNAME" ] ; then
echo "folder exist, Deleting..."
rm -Rf ./$DIRNAME
else
echo "folder not exist. continues..."
fi

rm -Rf ./apache-tomcat*
################## DOWNLOAD #################
#latest file
wget https://dlcdn.apache.org/tomcat/tomcat-9/v$VERSION/bin/$FILENAME

#archive file
wget https://archive.apache.org/dist/tomcat/tomcat-9/v$VERSION/bin/$FILENAME

#unzip
tar xvfz ./$FILENAME 


################## REMOVE NEEDLESS FOLDER #################
#find -type f ./$DIRNAME/webapps/ROOT -exec rm {} \;
rm -f ./$DIRNAME/webapps/ROOT/*.ico
rm -f ./$DIRNAME/webapps/ROOT/*.png
rm -f ./$DIRNAME/webapps/ROOT/*.jsp
rm -f ./$DIRNAME/webapps/ROOT/*.svg
rm -f ./$DIRNAME/webapps/ROOT/*.css
rm -f ./$DIRNAME/webapps/ROOT/*.gif
rm -f ./$DIRNAME/webapps/ROOT/*.txt

rm -Rf ./$DIRNAME/webapps/docs
rm -Rf ./$DIRNAME/webapps/examples
rm -Rf ./$DIRNAME/webapps/host-manager
rm -Rf ./$DIRNAME/webapps/manager

################## ADD SCRIPT #################
echo "tail -f ../logs/catalina.out" > ./$DIRNAME/bin/log.sh
chmod u+x ./$DIRNAME/bin/log.sh

################## CHECK IF AJP ACTIVE #################
echo "AJP(8009) active check"
AJP_CHECK_RESULT=$(cat ./$DIRNAME/conf/server.xml|sed '/<!--.*-->/d'|sed '/<!--/,/-->/d'|sed '/^\s*$/d'|grep "8009"|wc -l)
echo "AJP_CHECK_RESULT : " $AJP_CHECK_RESULT
if [ $AJP_CHECK_RESULT -gt 0 ] 
then
    echo "AJP PORT ACTIVE!"
else
    echo "AJP PORT INACTIVE"
fi

mv ./$DIRNAME/conf/server.xml ./$DIRNAME/conf/server.xml.orig
cat ./$DIRNAME/conf/server.xml.orig|sed -e '/<Connector.*HTTP/,/>/s/\/>/Server="HTOM" \/>/' > ./$DIRNAME/conf/server.xml.1
cat ./$DIRNAME/conf/server.xml.1|sed -e '/<Connector.*HTTP/,/>/s/8080/38080/' > ./$DIRNAME/conf/server.xml.2
cat ./$DIRNAME/conf/server.xml.2|sed -e '/<Host/,/<\/Host>/s/<\/Host>/<Valve className="org.apache.catalina.valves.ErrorReportValve" showReport="false" showServerInfo="false"\/><\/Host>/' > ./$DIRNAME/conf/server.xml

################## CHECK RESULT #################
ls -ltr
du -sm ./*
#tree ./
