// -----------------------------------------------------------
// EXPORT USER LIST WITH PROFILES FIRST!!!
// https://partnerconnect.my.salesforce.com/00Oo0000005IHrZ
// -----------------------------------------------------------

// Get Profile Ids and assign to vars
public Id partnerUserProfileId;

public Id distiAdminProfileId;
public Id distiFundMgrProfileId;
public Id distiUserProfileId;
public Id distiAFMProfileId;
public Id distiAFMNDProfileId;

public Id partnerAdminProfileId;
public Id partnerExecutiveProfileId;
public Id partnerFundMgrProfileId;
public Id partnerAFMProfileId;
public Id partnerAFMNDProfileId;

List<Profile> profileList = [SELECT Id, Name FROM Profile WHERE UserType = 'PowerPartner'];

for(Profile p : profileList){
	if (p.Name == 'Partner User') {
		partnerUserProfileId = p.Id;
		continue;
	} else if (p.Name == 'Disti Partner Admin') {
		distiAdminProfileId = p.Id;
		continue;
	} else if (p.Name == 'Disti Fund Manager') {
		distiFundMgrProfileId = p.Id;
		continue;
	} else if (p.Name == 'Disti Partner User') {
		distiUserProfileId = p.Id;
		continue;
	} else if (p.Name == 'DistiAdminAndFundManager') {
		distiAFMProfileId = p.Id;
		continue;
	} else if (p.Name == 'DistiAdminAndFundManager No Dashboard') {
		distiAFMNDProfileId = p.Id;
		continue;
	} else if (p.Name == 'Partner Admin') {
		partnerAdminProfileId = p.Id;
		continue;
	} else if (p.Name == 'Partner Executive') {
		partnerExecutiveProfileId = p.Id;
		continue;
	} else if (p.Name == 'Partner Fund Manager') {
		partnerFundMgrProfileId = p.Id;
		continue;
	} else if (p.Name == 'PartnerAdminAndFundManger') {
		partnerAFMProfileId = p.Id;
		continue;
	} else if (p.Name == 'PartnerAdminAndFundManger No Dashboard') {
		partnerAFMNDProfileId = p.Id;
	}
}

// Get list of Partner Users NOT using Partner User Profile
List<User> nonPartnerUsers = [SELECT Id, ContactId, AccountId, ProfileId FROM User WHERE UserType = 'PowerPartner' AND ProfileId != :partnerUserProfileId];
System.debug('Non Partner Users: ' + nonPartnerUsers.size());


// **********************************************************************
// Get list of Admin and Fund Managers to assign 2 of the 3 new Perm Sets
List<User> afmPartnerUsers = [SELECT Id, ContactId, AccountId, ProfileId FROM User WHERE UserType = 'PowerPartner' AND
								ProfileId in (:distiAdminProfileId, :distiFundMgrProfileId, :distiAFMProfileId, :distiAFMNDProfileId,
												:partnerAdminProfileId, :partnerFundMgrProfileId, :partnerAFMProfileId, :partnerAFMNDProfileId)];
System.debug('Admin and Fund Managers: ' + afmPartnerUsers.size());

// Add Admin and Fund Permission Sets
public Id adminPermSetId = [SELECT Id FROM PermissionSet WHERE Name = 'PRM_Partner_User_Partner_Admin'].Id;
System.debug('adminPermSetId is ' + adminPermSetId);
public Id fundMgrPermSetId  = [SELECT Id FROM PermissionSet WHERE Name = 'PRM_Partner_User_Fund_Management'].Id;
System.debug('fundMgrPermSetId is ' + fundMgrPermSetId);

List<PermissionSetAssignment> adminAndFundManagerPSAs = new List<PermissionSetAssignment>();
for (User afmUser : afmPartnerUsers) {
	PermissionSetAssignment adminPSA = new PermissionSetAssignment(PermissionSetId = adminPermSetId, AssigneeId = afmUser.Id);
	PermissionSetAssignment fundmgrPSA = new PermissionSetAssignment(PermissionSetId = fundmgrPermSetId, AssigneeId = afmUser.Id);
	adminAndFundManagerPSAs.add(adminPSA);
	adminAndFundManagerPSAs.add(fundmgrPSA);
}

// Insert the Perm Set Assignments and report whether it was successful or not
System.debug(adminAndFundManagerPSAs.size() + ' Admin and Fund Manager PermissionSetAssignments being inserted');
List<Database.SaveResult> saveResult1 = Database.insert(adminAndFundManagerPSAs,false);
for (Database.SaveResult sr:saveResult1) {
	if(!sr.isSuccess()){
		Database.Error err = sr.getErrors()[0];
		System.debug('Permission Set Assignment insert failed with message: ' + err);
	}
}


// **********************************************************************
// Add Dashbard Permission Set to Partner Executives
List<User> execPartnerUsers = [SELECT Id, ContactId, AccountId, ProfileId FROM User WHERE UserType = 'PowerPartner' AND ProfileId = :partnerExecutiveProfileId];
System.debug('Partner Execs: ' + execPartnerUsers.size());

// Add Dashboard Permission Set (different names in Prod vs Dev currently)
public Id dashboardPermSetId = [SELECT Id FROM PermissionSet WHERE Name in ('PartnerCommunityUsersDashBoardAccess', 'PRM_Partner_User_Dashboard_Access')].Id;
System.debug('dashboardPermSetId is ' + dashboardPermSetId);

List<PermissionSetAssignment> dashboardPSAs = new List<PermissionSetAssignment>();
for (User execUser : execPartnerUsers) {
	PermissionSetAssignment dashboardPSA = new PermissionSetAssignment(PermissionSetId = dashboardPermSetId, AssigneeId = execUser.Id);
	dashboardPSAs.add(dashboardPSA);
}

// Insert the Perm Set Assignments and report whether it was successful or not
System.debug(dashboardPSAs.size() + ' Dashboard PermissionSetAssignments being inserted');
List<Database.SaveResult> saveResult1 = Database.insert(dashboardPSAs,false);
for (Database.SaveResult sr:saveResult1) {
	if(!sr.isSuccess()){
		Database.Error err = sr.getErrors()[0];
		System.debug('Permission Set Assignment insert failed with message: ' + err);
	}
}


// *******************************************************
// Move everyone to Partner User Profile who isn't already
List<User> updatedNonPartnerUsers = new List<User>();
for (User pUser : nonPartnerUsers) {
	pUser.ProfileId = partnerUserProfileId;
	updatedNonPartnerUsers.add(pUser);
}

// Update the User Profiles and report whether it was successful or not
System.debug(updatedNonPartnerUsers.size() + 'Partner Users being moved to Partner User Profile. Should be equal to ' + nonPartnerUsers.size());
List<Database.SaveResult> saveResult2 = Database.update(updatedNonPartnerUsers,false);
for (Database.SaveResult sr:saveResult2) {
	if(!sr.isSuccess()){
		Database.Error err = sr.getErrors()[0];
		System.debug('Partner Users Profile Update failed with message: ' + err);
	}
}
