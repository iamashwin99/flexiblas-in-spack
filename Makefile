# Make file to install flexiblas via spack on docker 

v304:
	docker build -f Dockerfile --build-arg FLEXIBLAS_VERSION=3.0.4 -t flexiblas:3.0.4 .

v313:
	docker build -f Dockerfile --build-arg FLEXIBLAS_VERSION=3.1.3 -t flexiblas:3.1.3 .

v320:
	docker build -f Dockerfile --build-arg FLEXIBLAS_VERSION=3.2.0 -t flexiblas:3.2.0 .

v321:
	docker build -f Dockerfile --build-arg FLEXIBLAS_VERSION=3.2.1 -t flexiblas:3.2.1 .

v330:
	docker build -f Dockerfile --build-arg FLEXIBLAS_VERSION=3.3.0 -t flexiblas:3.3.0 .

	