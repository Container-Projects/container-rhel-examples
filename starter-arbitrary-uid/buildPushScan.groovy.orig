#!groovy

@Library('Utils')
import com.redhat.*

node {
    stage('checkout') {
        checkout scm
    }

    dockerBuildPush {
        credentialsId = "ContainerZone"
        contextDir = "starter-arbitrary-uid"
        imageName = "starter-arbitrary-uid"
        imageTag = "1.0"
    }

    containerZoneScan {
        credentialsId = "ContainerZone"
        openShiftUri = "insecure://api.rhc4tp.openshift.com"
        imageName = "starter-arbitrary-uid"
        imageTag = "1.0"
    }
}
