package org.b104.alfredo.jobs;

import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.quartz.JobListener;

public class FcmJobListener implements JobListener {

    @Override
    public String getName() {
        // Name must be unique for each listener, used to identify the listener uniquely.
        return "FcmJobListener";
    }

    @Override
    public void jobToBeExecuted(JobExecutionContext context) {
        System.out.println("Job is about to be executed: " + context.getJobDetail().getKey());
    }

    @Override
    public void jobExecutionVetoed(JobExecutionContext context) {
        System.out.println("Job execution was vetoed: " + context.getJobDetail().getKey());
    }

    @Override
    public void jobWasExecuted(JobExecutionContext context, JobExecutionException jobException) {
        if (jobException != null) {
            System.out.println("Job was executed with exception: " + jobException.getMessage());
        } else {
            System.out.println("Job was executed successfully: " + context.getJobDetail().getKey());
        }
    }
}