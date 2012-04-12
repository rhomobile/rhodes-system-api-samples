
#import "Nlist.h"

#include "ruby/ext/rho/rhoruby.h"

#import "NListTableViewController.h"
#import "NListViewManager.h"


void nlist_open_list(rho_param* params_hash, const char* callback) {

    [[NListViewManager getInstance] openView:prepareDictionary(params_hash, callback)];
    
}

void nlist_close_list() {
    [[NListViewManager getInstance] closeView];
}



