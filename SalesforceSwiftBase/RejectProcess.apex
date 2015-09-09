@RestResource(urlMapping='/RejectProcess/*')
global with sharing class RejectProcess {

    @HttpPost
    global static String reject(String processId) {
        ProcessInstanceWorkitem  p = [Select p.SystemModstamp, p.ProcessInstanceId, p.OriginalActorId,
            p.IsDeleted, p.Id, p.CreatedDate, p.CreatedById, p.Actor.Email,
            p.ActorId From ProcessInstanceWorkitem p where ProcessInstanceId=:processId];

            p.actorid= UserInfo.getUserId();
        update p;

        Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
        req.setAction('Reject');
        req.setWorkitemId(p.id);
        Approval.ProcessResult actResult = Approval.process(req);

        Return 'Done';
    }
}