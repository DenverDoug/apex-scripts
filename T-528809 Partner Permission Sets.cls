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

List<User> allPartnerUsers = [SELECT Id, ContactId, AccountId, ProfileId FROM User WHERE UserType = 'PowerPartner'];
System.debug('ALL Partner Users: ' + allPartnerUsers.size());

// Get list of Partner Users NOT using Partner User Profile
List<User> nonPartnerUsers = [SELECT Id, ContactId, AccountId, ProfileId FROM User WHERE UserType = 'PowerPartner' AND ProfileId != :partnerUserProfileId];
System.debug('Non Partner Users: ' + nonPartnerUsers.size());

// Get list of Admin and Fund Managers to assign 2 of the 3 new Perm Sets
List<User> afmPartnerUsers = [SELECT Id, ContactId, AccountId, ProfileId FROM User WHERE UserType = 'PowerPartner' AND
								ProfileId in (:distiAdminProfileId, :distiFundMgrProfileId, :distiAFMProfileId, :distiAFMNDProfileId,
												:partnerAdminProfileId, :partnerFundMgrProfileId, :partnerAFMProfileId, :partnerAFMNDProfileId)];
System.debug('Admin and Fund Managers: ' + afmPartnerUsers.size());

// #TODO add Admin Perm Set
// #TODO add Fund Manager Perm Set

// Get list of Admin and Fund Managers not using No Dashboard Profiles to add the final Perm Set for Dashboard Access
// #TODO - SHOULD THIS JUST BE A DATA LOAD BASED ON CURRENT PROD GROUP?
// https://partnerconnect.my.salesforce.com/005?id=0PSo0000000AYw1&isUserEntityOverride=1
/* List<User> dashboardPartnerUsers = [SELECT Id, ContactId, AccountId, ProfileId FROM User WHERE UserType = 'PowerPartner' AND
								ProfileId in (:distiAdminProfileId, :distiFundMgrProfileId, :distiAFMProfileId,
												:partnerAdminProfileId, partnerFundMgrProfileId, :partnerAFMProfileId)];
System.debug('Dashboard Users: ' + dashboardPartnerUsers.size());

// #TODO add Dashboard Perm Set
*/

// Move everyone to Partner User Profile who isn't already
List<User> updatedNonPartnerUsers = new List<User>();

for (pUser : nonPartnerUsers) {
	pUser.ProfileId = partnerUserProfileId;
	updatedNonPartnerUsers.add(pUser);
}
update updatedNonPartnerUsers;


