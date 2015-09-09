@RestResource(urlMapping='/ApproveProcess/*')
global with sharing class ApproveProcess {

    @HttpPost
    global static String approve(String processId) {
       ProcessInstanceWorkitem  p = [Select p.SystemModstamp, p.ProcessInstanceId, p.OriginalActorId,
          p.IsDeleted, p.Id, p.CreatedDate, p.CreatedById, p.Actor.Email,
          p.ActorId From ProcessInstanceWorkitem p where ProcessInstanceId=:processId];

     p.actorid= UserInfo.getUserId();
     update p;

      Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
      req.setAction('Approve');
      req.setWorkitemId(p.id);
      Approval.ProcessResult actResult = Approval.process(req);

      Return 'Done';
   }
}
