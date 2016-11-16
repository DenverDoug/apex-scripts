// -------------------------------------------------------------------------------------
// Insert Sales Read Only Perm Set for Channel Ops and Business Admin Profiles



// -----------------------------------------------------------------------------
// Update Usernames for internal and external user to have .hds suffix



//-----------------------------------
// Delete Partner Prospects

Account[] prospectAccts = [SELECT Id, Name, RecordType FROM Account WHERE Name = 'DotCom'];
try {
    delete prospectAccts;
} catch (DmlException e) {
    System.debug('Deleting ' + prospectAccts.size() + ' Prospect Accounts');

}
