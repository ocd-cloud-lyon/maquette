/*
    This is an example pipeline that implement full CI/CD for a simple static web site packed in a Docker image.
    The pipeline is made up of 6 main steps
    1. Git clone and setup
    2. Build and local tests
    3. Publish Docker and Helm
    4. Deploy to dev and test
    5. Deploy to staging and test
    6. Optionally deploy to production and test
 */
 def createNamespace (namespace) {
    echo "Creating namespace ${namespace} if needed"

    sh "[ ! -z \"\$(kubectl get ns ${namespace} -o name 2>/dev/null)\" ] || kubectl create ns ${namespace}"
}

 
 /*
    This is the main pipeline section with the stages of the CI/CD
 */
 pipeline {

    options {
        // Build auto timeout
        timeout(time: 60, unit: 'MINUTES')
    }
     // Some global default variables
    environment {
        //registry = "bvarnet/maquette-v1-dev"
	registry = "https://573329840855.dkr.ecr.eu-west-3.amazonaws.com"
        //registryCredential = 'docker-hub-credentials'
	registryCredential = 'ecr:eu-west-3:aws-ecr-credential'
        dockerImage = ''
        NomProjet = 'hello-you'
        NameSpace = 'hello-you-ns'
	DeployName = 'hello-you-deploy'
	ServiceName = 'hello-you-srv'
    }

     agent any

    // Pipeline stages
     stages {
         stage('Clone repository') {
            /* Let's make sure we have the repository cloned to our workspace */
             steps {
                //checkout scm
		git credentialsId: 'github-credential', url: 'https://github.com/ocd-cloud-lyon/maquette/'
             }

        }

        stage('Build image') {
          steps{
            script {
              //dockerImage = docker.build registry + ":$BUILD_NUMBER"
		docker.build('ocd-cloud-lyon')
            }
          }
        }
	
	//attendre un peu que l'image soit dispo
	/*stage ('wait 30s'){
		steps{
			sleep 30
		}
	}*/
	     
	     
	stage ('Scan_prisma'){
		steps{
			twistlockScan ca: '', cert: '', compliancePolicy: 'warn', containerized: false, dockerAddress: 'unix:///var/run/docker.sock', gracePeriodDays: 15, ignoreImageBuildTime: false, image: 'ocd-cloud-lyon', key: '', logLevel: 'true', policy: 'critical', requirePackageUpdate: true, timeout: 10
			twistlockPublish ca: '', cert: '', dockerAddress: 'unix:///var/run/docker.sock', image: 'ocd-cloud-lyon', key: '', logLevel: 'true', timeout: 10
		}
	}
	     /*stage('Scan image'){
		steps{
      			//aquaMicroscanner imageName: 'ocd-cloud-lyon', notCompliesCmd: '', onDisallowed: 'ignore', outputFormat: 'html'
			//aqua customFlags: '', hideBase: false, hostedImage: '', localImage: 'sma-maquette', locationType: 'local', notCompliesCmd: '', onDisallowed: 'ignore', policies: '', register: false, registry: '', showNegligible: false
		}
        }*/
    
        stage('Push Image') {
          steps{
            script {
              //docker.withRegistry( '', registryCredential ) {
              //  dockerImage.push()
		docker.withRegistry(registry, registryCredential) {
    		docker.image('ocd-cloud-lyon').push('latest')
		docker.image('ocd-cloud-lyon').push("${env.BUILD_NUMBER}")
              }
            }
          }
        }
	     
	//Suppression de l'image
	stage ('delete docker image'){
		steps{
		      sh "docker rmi 573329840855.dkr.ecr.eu-west-3.amazonaws.com/ocd-cloud-lyon:latest"
		      sh "docker rmi 573329840855.dkr.ecr.eu-west-3.amazonaws.com/ocd-cloud-lyon:${env.BUILD_NUMBER}"
		      sh "docker rmi ocd-cloud-lyon:latest"
		}
	}
         stage('deploy') {
		 steps {
			 /*script {
				 // deploiment en un coup dans le namespace default
				 sh ("/usr/local/bin/helm upgrade --install ${NomProjet} ./hello-you --set image.version=${BUILD_NUMBER}")
				 // deploiment en un coup dans le namespace NameSpace
				 //sh ("/usr/local/bin/helm upgrade --install ${NomProjet} ./hello-you --namespace ${NameSpace} --set image.version=${BUILD_NUMBER}")
			 }*/
			 kubernetesDeploy configs: 'deploy-app.yaml', kubeConfig: [path: ''], kubeconfigId: 'K8S-config', secretName: 'ecr:eu-west-3:aws-ecr-credential', ssh: [sshCredentialsId: '*', sshServer: ''], textCredentials: [certificateAuthorityData: '', clientCertificateData: '', clientKeyData: '', serverUrl: 'https://']
			 kubernetesDeploy configs: 'deploy-svc.yaml', kubeConfig: [path: ''], kubeconfigId: 'K8S-config', secretName: 'ecr:eu-west-3:aws-ecr-credential', ssh: [sshCredentialsId: '*', sshServer: ''], textCredentials: [certificateAuthorityData: '', clientCertificateData: '', clientKeyData: '', serverUrl: 'https://']
			 script {
				 //def LB_NAME = sh(script: 'kubectl get svc hello-you-svc -o jsonpath="{..hostname}" | cut -d- -f2', returnStdout: true)
				 LB_NAME = sh(script: ' kubectl get service hello-you-svc -o jsonpath="{..hostname}" | cut -d- -f2',returnStdout: true).trim()
			 }
			 echo "nom du LB: ${LB_NAME}" 	 
		 }

        }
	stage ('Publish_prisma'){
		steps{
			twistlockPublish ca: '', cert: '', dockerAddress: 'unix:///var/run/docker.sock', image: 'ocd-cloud-lyon', key: '', logLevel: 'true', timeout: 10
		}
	}
	
	/*stage ('Deploy Validation'){
		steps{
			//error 'deploy failed'
		}
	}*/
	
    }
}
