pipeline {

    // Instructs Jenkins to use the buildconductor docker image to run this pipeline Test
    
    agent {
        docker { 
            image 'greghodgkinson/jenkins-buildconductor-iib:edge' 
            label 'docker'
            args '-u root'
        }
        
    }

    stages {
    
        // Pull down source code from Git repo
        
       stage('Checkout Code'){
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/feature']], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'RelativeTargetDirectory', relativeTargetDir: 'load']], submoduleCfg: [], userRemoteConfigs: [[url: 'https://github.com/sitaramaprasad-e/dte-commonFramework-iib.git']]])
            }
          
       }   
       
       stage('Checkout .brokerFile'){
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'RelativeTargetDirectory', relativeTargetDir: 'brokerFiles-load']], submoduleCfg: [], userRemoteConfigs: [[url: 'https://github.com/sitaramaprasad-e/brokerFiles-iib.git']]])
            }
          
       }  
       
       // Build BAR file from source code
       
        stage('Build BAR') {
            steps {
                sh "/buildconductor/iib/run-automation.sh build commonframework 'RetryApplication PROLIFICS_LOG4J_LOGGING PRO_COMMON_UTIL_SHAREDLIB commonExceptionHandler" 
            }
        }   
        
        // Either override and deploy the BAR (with or without broker file), or upload it to UCD so it can be deployed from there (one of the below steps should be uncommented)
        
        stage('Override and Deploy BAR') {
         steps {
                sh "/buildconductor/iib/run-automation.sh overrideAndDeploy commonframework na na na PBCIS webuser1 passw0rd TemperatureConverter TemperatureConverter/overrides/development.properties ../brokerFiles-load/DEV/PBCNODE.broker"
        
          }
        }       
    }
	// Sending email notifications
	post {
        always {
            echo 'I will always say Hello again!!!'
            
            emailext body: "${currentBuild.currentResult}: Job ${env.JOB_NAME} build ${env.BUILD_NUMBER}\n More info at: ${env.BUILD_URL}",
                recipientProviders: [[$class: 'DevelopersRecipientProvider'], [$class: 'RequesterRecipientProvider']],
                subject: "Jenkins Build ${currentBuild.currentResult}: Job ${env.JOB_NAME}"
            
        }
    }
}
