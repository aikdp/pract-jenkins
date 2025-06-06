def call(Map envMap){
    pipeline{
        //agent any
        agent{
            label 'AGENT-1'
        }
        options{
            disableConcurrentBuilds() 
            // retry(2)    //it will retry 2 times, if pipeline failure
            timeout(time: 30, unit: 'MINUTES') //pipeline will stop/abort when specified time period
            ansiColor('xterm')
        }
        environment{
            project = envMap.PROJECT
            environment = envMap.ENVIRONMENT
            component = envMap.COMPONENT
            region = envMap.REGION
            aws_account_id = '537124943253'
        }
        parameters {
            // string(name: 'component', defaultValue: 'backend', description: 'Component name')
            // choice(name: 'ENVIRONMENT', choices: ['dev', 'qa', 'uat', 'pre-pod', 'prod'], description: 'Select environment')
            // string(name: 'region', defaultValue: 'us-east-1', description: 'Region is')
            booleanParam(name: 'deploy', defaultValue: false, description: 'deploy this')
        }
        stages{
            stage("Read Vesrion"){
                steps{
                    script {
                        // dir('backend/node'){
                            // Read the JSON file
                            def packageJson = readJSON file: 'package.json'
                            imageVersion = packageJson.version
                            // Access JSON properties
                            // echo "Version is: ${packageJson.version}"   //you can directly use this line as well
                            echo "Version is: ${imageVersion}"
                        // }
                    }          
                }
            }
            //Installing dependencies that are mentioned in the package.json file for nodejs(For Java--> pom.xml, mvn package manager)
            stage("Install dependencies"){
                steps{
                    sh """
                        npm install
                    """
                }//backend/node  removed
            }
            // //SOnarQube code quality check
            // stage('SonarQube analysis') {
            //     environment {
            //         SCANNER_HOME = tool 'sonar-6.0'
            //     }
            //     steps {
            //         withSonarQubeEnv(credentialsId: 'sonar-token', installationName: 'Sonar') {
            //             sh """
            //                 $SCANNER_HOME/bin/sonar-scanner 
            //             """
            //         }
            //     }
            // }
            // //Sonar QUality Wait for PASS, if FAILED, build also FAIL.
            // stage('Sonar Quality Gate') {
            //     steps {
            //         timeout(time: 5, unit: 'MINUTES') {
            //             waitForQualityGate abortPipeline: true
            //         }
            //     }
            // }
            //install docker in jenkins agent
            stage("Build docker Image"){
                steps{
                    withCredentials([aws(credentialsId: "aws-creds")]) {
                        sh """
                            
                            aws ecr get-login-password --region ${region} | docker login --username AWS --password-stdin ${aws_account_id}.dkr.ecr.us-east-1.amazonaws.com

                            docker build -t ${aws_account_id}.dkr.ecr.us-east-1.amazonaws.com/${project}/${environment}/${component}:${imageVersion} .
                        
                            docker images

                            docker push ${aws_account_id}.dkr.ecr.us-east-1.amazonaws.com/${project}/${environment}/${component}:${imageVersion}
                        """
                    }//  cd backend removed
                }
            }
            // You should have INFRA Ready ready(MySQL ALso), before run this stage
            /*stage("Trigger Deploy image to K8s"){
                when {
                    expression {params.deploy}
                }
                steps{
                   build job: '../BACKEND-CD', parameters: [
                       [$class: 'StringParameterValue', name: 'ENVIRONMENT', value: "${environment}"],
                       [$class: 'StringParameterValue', name: 'component', value: "${component}"],
                       [$class: 'StringParameterValue', name: 'region', value: "${region}"],
                       [$class: 'StringParameterValue', name: 'version', value: "${imageVersion}"]
                       ]
                   }
            }*/
            stage('Trigger Deploy to EKS') {
                when {
                    expression {params.deploy}
                }
                steps {
                    // Trigger the second pipeline
                    // build job: 'shared-pipeline-backend/backend-shared-cd', parameters: [
                    build job: '../backend-cd', parameters: [
                        //these parameters or env vars passed to BACKEND-CD, u can access there
                        string(name: 'component', value: "${component}"),
                        string(name: 'ENVIRONMENT', value: "${environment}"),
                        string(name: 'region', value: "${region}"),
                        string(name: 'version', value: "${imageVersion}")
                    ], wait: true
                }
            }
        }
        post{
            //post build section
            always{
                echo "I always run when pipeline running"
                deleteDir()    //Cleans up workspace after every build.
            }
            failure{
                echo "Pipeline is FAILED"
            }
            success {
                echo "Pipeline is Success"
            }
            regression {
                echo "It will execute if Pipeline status is failure, unstable, or aborted and the previous run was successful"
            }
        }
    }
}