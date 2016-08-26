// ******************************************
//                 PRIORS
// ******************************************
final String uDoug = '005o0000001q8AjAAI';
final String uDawn = '005o0000001E8dXAAS';
final String uSheri = '005o0000001E9cbAAC';
final String uWinnie = '005o0000001E8cuAAC';

List<Prior_HDS__c> priors = Database.query(
	'SELECT Name, Partner_HDS__c, Status_HDS__c, Fund_GEO_HDS__c, Approver_1_HDS__c, CreatedById, CreatedDate FROM Prior_HDS__c WHERE Approver_1_HDS__c = :uDoug AND Status_HDS__c = \'Submitted\'');

List<Prior_HDS__c> updatedPriors = new List<Prior_HDS__c>();

for (Prior_HDS__c p : priors) {
     if (p.Status_HDS__c == 'Submitted') {
     	if (p.Fund_GEO_HDS__c == 'AMERICAS') {
     		p.Approver_1_HDS__c = uDawn;
 		} else if (p.Fund_GEO_HDS__c == 'APAC') {
 			p.Approver_1_HDS__c = uWinnie;
 		} else if (p.Fund_GEO_HDS__c == 'EMEA') {
 			p.Approver_1_HDS__c = uSheri;
 		}
     }
     updatedPriors.add(p);
}
update updatedPriors;


// ******************************************
//                APPROVALS
// ******************************************
final String uDoug = '005o0000001q8AjAAI';
final String qAMERICASchops= '00Go0000000PPLs';
final String qAPACchops= '00Go0000000PPLt';
final String qEMEAchops= '00Go0000000PPLw';

List<ProcessInstanceWorkitem> pendingApprovalReqs = Database.query(
	'SELECT p.Id, p.ActorId, p.ProcessInstance.TargetObjectId, p.ProcessInstance.TargetObjectId.Fund_GEO_HDS__c ' +
    'FROM ProcessInstanceWorkItem p ' +
    'WHERE p.ActorId = :uDoug');

List<ProcessInstanceWorkitem> updatedPendingApprovalReqs = new List<ProcessInstanceWorkitem>();

for (ProcessInstanceWorkitem par : pendingApprovalReqs) {
	if (par.ProcessInstance.TargetObject.Fund_GEO_HDS__c == 'AMERICAS') {
 		par.ActorId = qAMERICASchops;
	} else if (par.ProcessInstance.TargetObject.Fund_GEO_HDS__c == 'APAC') {
		par.ActorId = qAPACchops;
	} else if (par.ProcessInstance.TargetObject.Fund_GEO_HDS__c == 'EMEA') {
		par.ActorId = qEMEAchops;
	}
	updatedPendingApprovalReqs.add(par);
}

update(updatedPendingApprovalReqs);


// ******************************************
//           DUMMY UPDATE ACCOUNT
// ******************************************





// ******************************************
//           DUMMY UPDATE CONTACT
// ******************************************


