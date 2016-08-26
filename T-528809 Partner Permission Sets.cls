// -----------------------------------------------------------
// EXPORT USER LIST WITH PROFILES FIRST!!!
// https://partnerconnect.my.salesforce.com/00Oo0000005IHrZ
// -----------------------------------------------------------

// Get Profile Ids and assign to vars
public Id partnerUserProfileId;
public Id distiAFMProfileId;
public Id distiAFMNDProfileId;
public Id distiUserProfileId;
public Id partnerAdminProfileId;
public Id partnerAFMProfileId;
public Id partnerAFMNDProfileId;
public Id partnerExecutiveProfileId;

List<Profile> profileList = [SELECT Id, Name FROM Profile WHERE UserType = 'PowerPartner'];

for(Profile p : profileList){

	if (p.Name == 'Partner User') {
		partnerUserProfileId = p.Id;
	} else if (p.Name == 'DistiAdminAndFundManager') {
		distiAFMProfileId = p.Id;
	} else if (p.Name == 'DistiAdminAndFundManager No Dashboard') {
		distiAFMNDProfileId = p.Id;
	} else if (p.Name == 'Disti Partner User') {
		distiUserProfileId = p.Id;
	} else if (p.Name == 'Partner Admin') {
		partnerAdminProfileId = p.Id;
	} else if (p.Name == 'PartnerAdminAndFundManger') {
		partnerAFMProfileId = p.Id;
	} else if (p.Name == 'PartnerAdminAndFundManger No Dashboard') {
		partnerAFMNDProfileId = p.Id;
	} else if (p.Name == 'Partner Executive') {
		partnerExecutiveProfileId = p.Id;
	}
	System.debug(p.Name);
}

// Get list of Partner Users NOT using Partner User Profile
List<User> nonPartnerUsers = [SELECT Id, ContactId, AccountId, ProfileId FROM User WHERE ProfileId != :partnerUserProfileId];
System.debug(nonPartnerUsers.size());

// Get list of Admin and Fund Managers to get 2 of the 3 new Perm Sets
List<User> afmPartnerUsers = [SELECT Id, ContactId, AccountId, ProfileId FROM User WHERE ProfileId in (:distiAFMProfileId, :distiAFMNDProfileId, :partnerAdminProfileId, :partnerAFMProfileId, :partnerAFMNDProfileId)];

// #TODO add Admin Perm Set
// #TODO add Fund Manager Perm Set

// Get list of Admin and Fund Managers not using No Dashboard Profiles to add the final Perm Set for Dashboard Access
List<User> dashboardPartnerUsers = [SELECT Id, ContactId, AccountId, ProfileId FROM User WHERE ProfileId in (:distiAFMProfileId, :partnerAdminProfileId, :partnerAFMProfileId)];
// #TODO add Dashboard Perm Set


// Move everyone to Partner User Profile who isn't already
List<User> updatedNonPartnerUsers = new List<User>();

for (pUser : nonPartnerUsers) {
	pUser.ProfileId = partnerUserProfileId;
	updatedNonPartnerUsers.add(pUser);
}
update updatedNonPartnerUsers;


