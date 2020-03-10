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
		RuningImageBuild = 0
		TargetImageBuild = 0
    }

    agent any

    // Pipeline stages
     stages {
         stage('Clone repository') {
            /* Let's make sure we have the repository cloned to our workspace */
             steps {
                //checkout scm
				script{
					FAILED_STAGE=env.STAGE_NAME
					echo "Clone repository"
				}
				git credentialsId: 'github-credential', url: 'https://github.com/ocd-cloud-lyon/maquette/'
             }

        }

	    stage('Build image') {
	    	steps {
	        	script {
					FAILED_STAGE=env.STAGE_NAME
					echo "Build image"
					docker.build('ocd-cloud-lyon')
					BUILD_DONE = 1		
	            }
	        }
	    }
     
	     
		stage ('Scan_prisma'){
			steps {
				script { 
					FAILED_STAGE=env.STAGE_NAME
					echo "Scan Prisma"
					Prisma_Scan_launched = 1
				}
				twistlockScan 	ca: '',
							 	cert: '', 
							 	compliancePolicy: 'warn', 
							 	containerized: false, 
							 	dockerAddress: 'unix:///var/run/docker.sock', 
							 	gracePeriodDays: 15, 
							 	ignoreImageBuildTime: true, 
							 	image: 'ocd-cloud-lyon:latest', 
							 	key: '', 
							 	logLevel: 'true', 
							 	policy: 'high', 
							 	requirePackageUpdate: true, 
							 	timeout: 10

				echo "scan completed"
				//twistlockPublish ca: '', cert: '', dockerAddress: 'unix:///var/run/docker.sock', image: 'ocd-cloud-lyon:latest', key: '', logLevel: 'true', timeout: 10
				//echo "published completed"
			}
		}

		/*stage('Scan_Aqua'){
			steps{
				script { 
					FAILED_STAGE=env.STAGE_NAME
					echo "Scan_Aqua"
				}
	      		//aquaMicroscanner imageName: 'ocd-cloud-lyon', notCompliesCmd: '', onDisallowed: 'ignore', outputFormat: 'html'
				//aqua customFlags: '', hideBase: false, hostedImage: '', localImage: 'sma-maquette', locationType: 'local', notCompliesCmd: '', onDisallowed: 'ignore', policies: '', register: false, registry: '', showNegligible: false
			}
	    }*/
    
	    stage('Push Image') {
	    	steps{
	            script {
	            	FAILED_STAGE=env.STAGE_NAME
					echo "Push Image"
					docker.withRegistry(registry, registryCredential) {
	    				docker.image('ocd-cloud-lyon').push('latest')
						docker.image('ocd-cloud-lyon').push("${env.BUILD_NUMBER}")
	            	}
	           	}
	        }
	 	}

	     
		//Suppression de l'image
		stage ('delete docker image'){
			steps {
			      script{
			      	FAILED_STAGE=env.STAGE_NAME
					echo "delete docker image"
			      }
			      sh "docker rmi 573329840855.dkr.ecr.eu-west-3.amazonaws.com/ocd-cloud-lyon:latest"
			      sh "docker rmi 573329840855.dkr.ecr.eu-west-3.amazonaws.com/ocd-cloud-lyon:${env.BUILD_NUMBER}"
			}
		}
    
	    stage('deploy') {
			steps {
				script{
			      	FAILED_STAGE=env.STAGE_NAME
					echo "delete docker image"
			    }

				kubernetesDeploy configs: 'deploy-app.yaml', kubeConfig: [path: ''], kubeconfigId: 'K8S-config', secretName: 'ecr:eu-west-3:aws-ecr-credential', ssh: [sshCredentialsId: '*', sshServer: ''], textCredentials: [certificateAuthorityData: '', clientCertificateData: '', clientKeyData: '', serverUrl: 'https://']
				kubernetesDeploy configs: 'deploy-svc.yaml', kubeConfig: [path: ''], kubeconfigId: 'K8S-config', secretName: 'ecr:eu-west-3:aws-ecr-credential', ssh: [sshCredentialsId: '*', sshServer: ''], textCredentials: [certificateAuthorityData: '', clientCertificateData: '', clientKeyData: '', serverUrl: 'https://']
				
				//validate deployement
				sleep 30
				script {
	                withKubeConfig(caCertificate: '', clusterName: '', contextName: '', credentialsId: 'kubeconfig-file', namespace: '', serverUrl: '') {
	                    //RuningImageBuild = sh (script: 'kubectl get pods --all-namespaces -o jsonpath="{..image}" -l app=hello-you |tr -s "[[:space:]]" "\n" | uniq -c | cut -d: -f2', returnStdout: true)
	                    RuningImageBuild = sh (script: 'kubectl get pods --all-namespaces -o jsonpath="{..image}" -l app=hello-you --field-selector=status.phase=Running |tr -s "[[:space:]]" "\n" | uniq -c | cut -d: -f2', returnStdout: true)
	                
	                }

	                TargetImageBuild = env.BUILD_NUMBER.toInteger()

	                if (RuningImageBuild.toInteger() == TargetImageBuild ) {
	                	echo "Build successfull"
	                } else {
	                	echo "Build failed"
	                	error 'deploy failed'
	                }
	            }
			}

	    }
	}
    post {
        always {
        	script {
        		if (Prisma_Scan_launched == 1){
        			script {
        				echo "scan lancé maintenant on pousse les resultats"
        				twistlockPublish ca: '', cert: '', dockerAddress: 'unix:///var/run/docker.sock', image: 'ocd-cloud-lyon:latest', key: '', logLevel: 'true', timeout: 10
        				echo "publish effectué"
        			}
        		}
        		if (BUILD_DONE == 1 ) {
    				echo "on efface l'image locale latest"
    				sh "docker rmi ocd-cloud-lyon:latest"
        		}
        	}
        }
        success {
        	echo "Build successfull"
        	slackSend channel: '#général', message: "Build ${env.BUILD_NUMBER} successfull"
        	build job: 'Publish-Service', parameters: [string(name: 'Serv_Name', value: "${ServiceName}")]
   		}
        failure {
            echo "Failed stage name: ${FAILED_STAGE}"
            slackSend channel: '#général', message: "Build ${env.BUILD_NUMBER} Failed at stage ${FAILED_STAGE} please visit Jenkins at  ${BUILD_URL}"
        }
    }
	
	/*stage ('Publish_prisma'){
		steps{
			twistlockPublish ca: '', cert: '', dockerAddress: 'unix:///var/run/docker.sock', image: 'ocd-cloud-lyon', key: '', logLevel: 'true', timeout: 10
		}
	}/*
	
	/*stage ('Deploy Validation'){
		steps{
			//error 'deploy failed'
		}
	}*/
}
