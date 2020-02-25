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
	env.KUBERNETES_SECRET_NAME = registryCredential
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
         stage('deploy') {
		 steps {
			 /*script {
				 // deploiment en un coup dans le namespace default
				 sh ("/usr/local/bin/helm upgrade --install ${NomProjet} ./hello-you --set image.version=${BUILD_NUMBER}")
				 // deploiment en un coup dans le namespace NameSpace
				 //sh ("/usr/local/bin/helm upgrade --install ${NomProjet} ./hello-you --namespace ${NameSpace} --set image.version=${BUILD_NUMBER}")
			 }*/
			 kubernetesDeploy configs: 'test-deploy.yaml', kubeConfig: [path: ''], kubeconfigId: 'K8S-config', secretName: '', ssh: [sshCredentialsId: '*', sshServer: ''], textCredentials: [certificateAuthorityData: '', clientCertificateData: '', clientKeyData: '', serverUrl: 'https://']
		 }

        }
    }
}
