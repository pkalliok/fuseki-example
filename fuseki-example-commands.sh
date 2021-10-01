# start Fuseki in a docker container
docker run -it --rm -p 3030:3030 -e ADMIN_PASSWORD=jukkapalmu \
	--name test-fuseki stain/jena-fuseki

# create a dataset (= db) to work on
curl -i -u admin:jukkapalmu -X POST http://localhost:3030/$/datasets \
	-d dbName=pkalliok-example-dataset -d dbType=tdb

# load some data from Turtle format (see aiven.ttl)
curl http://localhost:3030/pkalliok-example-dataset/data \
	-H 'Content-type: text/turtle' -d @aiven.ttl

# query all services
curl http://localhost:3030/pkalliok-example-dataset/query \
	--data-urlencode 'query=SELECT ?s
	WHERE { ?s a <http://rdf.aiven.io/kinds/class/Service> }'

# joins: get the project(s) whose any service is called "pkalliok-os".
curl http://localhost:3030/pkalliok-example-dataset/query \
	--data-urlencode 'query=
	PREFIX rel: <http://rdf.aiven.io/kinds/relation/>
	SELECT ?p ?name
	WHERE { ?s rel:belongs_to ?p .
		?p rel:name ?name .
		?s rel:name "pkalliok-os" . }'

