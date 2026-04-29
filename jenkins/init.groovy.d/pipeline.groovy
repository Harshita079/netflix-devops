import jenkins.model.*
import org.jenkinsci.plugins.workflow.job.*
import org.jenkinsci.plugins.workflow.cps.*
import hudson.plugins.git.*

def jenkins = Jenkins.instance

def jobName = "netflix-pipeline"

if (jenkins.getItem(jobName) == null) {

    def job = jenkins.createProject(WorkflowJob, jobName)

    def scm = new GitSCM("https://github.com/Harshita079/netflix-devops.git")

    def definition = new CpsScmFlowDefinition(scm, "Jenkinsfile")
    job.setDefinition(definition)

    job.save()

    println("Pipeline created automatically!")
}