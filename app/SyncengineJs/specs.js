describe("Syncengine API", function(){

    describe("API loading", function(){
        it("should be defined", function(){
            expect(api).toBeSet();

            expect(api.set_threaded_mode).toBeSet();
            expect(api.enable_status_popup).toBeSet();
            expect(api.set_ssl_verify_peer).toBeSet();
            expect(api.register_push).toBeSet();

            expect(api.set_syncserver).toBeSet();
            expect(api.set_pollinterval).toBeSet();
            expect(api.get_pollinterval).toBeSet();
            expect(api.set_pagesize).toBeSet();
            expect(api.get_pagesize).toBeSet();

            expect(api.login).toBeSet();
            expect(api.logged_in).toBeSet();
            expect(api.logout).toBeSet();

            expect(api.dosync).toBeSet();
            expect(api.dosync_source).toBeSet();
            expect(api.is_syncing).toBeSet();
            expect(api.stop_sync).toBeSet();

            expect(api.set_objectnotify).toBeSet();
            expect(api.clean_objectnotify).toBeSet();
        });
    });


    describe("API configuration", function(){
        testSetGetValue([
            {
                label: "should be able to toggle threaded mode",
                funcNameSet: "set_threaded_mode",
                values: [false, true],
                resultTest: resultIsOk
            },
            {
                label: "should be able to toggle status popup",
                funcNameSet: "enable_status_popup",
                values: [true, false],
                resultTest: resultIsOk
            },
            {
                label: "should be able to toggle SSL peer verification",
                funcNameSet: "set_ssl_verify_peer",
                values: [true, false],
                resultTest: resultIsOk
            },
            {
                label: "should be able to set sync server URL",
                funcNameSet: "set_syncserver",
                values: ['http://rhodes-samples-server.heroku.com/application'],
                resultTest: resultIsOk
            },
            {
                label: "should be able to set object notifications handler",
                funcNameSet: "set_objectnotify",
                values: [function(notification){}],
                resultTest: resultIsOk
            },
            {
                label: "should be able to change poll interval",
                funcNameSet: "set_pollinterval",
                funcNameGet: "get_pollinterval",
                values: [0, 100, 200, 0],
                resultTest: resultIsNumber
            },
            {
                label: "should be able to change page size",
                funcNameSet: "set_pagesize",
                funcNameGet: "get_pagesize",
                values: [100, 500, 1000, 2000],
                resultTest: resultIsNumber
            }
        ], 1000);

        testIsOk([
            {
                label: "should be able to register push",
                funcName: "register_push"
            },
            {
                label: "should be able to clean object notifications",
                funcName: "clean_objectnotify"
            },
        ], 1000);
    });

    describe("API usage", function(){

        var okHdlr = jasmine.createSpy('for ok');
        var errHdlr = jasmine.createSpy('for errors');
        var callbackHdlr = jasmine.createSpy('for callback');

        it("should be logged out by default", function(){
            runs(function(){
                api.logged_in(okHdlr, errHdlr);
            });
            waitsForSpies([okHdlr, errHdlr], 'logged_in timeout', 1000);
            runs(function(){
                expect(errHdlr).not.toHaveBeenCalled();
                if(0 < errHdlr.callCount) jasmine.log('errHdlr called with: ' +errHdlr.mostRecentCall.args);
                expect(okHdlr).toHaveBeenCalled();
                if (0 < okHdlr.callCount) {
                    jasmine.log('result is ' +okHdlr.mostRecentCall.args[0]);
                    expect("false" == okHdlr.mostRecentCall.args[0]).toBeTruthy();
                }
            });
        });

        it("should login ok", function(){
            runs(function(){
                api.login(userlogin, userpass, callbackHdlr, okHdlr, errHdlr);
            });
            waitsForSpies([okHdlr, errHdlr], 'login timeout', 1000);
            runs(function(){
                expect(errHdlr).not.toHaveBeenCalled();
                if(0 < errHdlr.callCount) jasmine.log('errHdlr called with: ' +errHdlr.mostRecentCall.args);
                expect(okHdlr).toHaveBeenCalled();
                if (0 < okHdlr.callCount) {
                    jasmine.log('result is ' +okHdlr.mostRecentCall.args[0]);
                    expect("ok" == okHdlr.mostRecentCall.args[0]).toBeTruthy();
                }
            });
            waitsForSpies([callbackHdlr], 'login callback timeout', 10000);
            runs(function(){
                expect(callbackHdlr).toHaveBeenCalled();
                if (0 < callbackHdlr.callCount) {
                    jasmine.log('result is ' +callbackHdlr.mostRecentCall.args[0]);
                    expect(callbackHdlr.mostRecentCall.args[0].match(/^error_code=0/)).toBeTruthy();
                }
            });
            runs(function(){
                api.logged_in(okHdlr, errHdlr);
            });
            waitsForSpies([okHdlr, errHdlr], 'logged_in timeout', 1000);
            runs(function(){
                expect(errHdlr).not.toHaveBeenCalled();
                if(0 < errHdlr.callCount) jasmine.log('errHdlr called with: ' +errHdlr.mostRecentCall.args);
                expect(okHdlr).toHaveBeenCalled();
                if (0 < okHdlr.callCount) {
                    jasmine.log('result is ' +okHdlr.mostRecentCall.args[0]);
                    expect("true" == okHdlr.mostRecentCall.args[0]).toBeTruthy();
                }
            });
        });

        describe("API synchronization features", function(){

            it("should sync all sources", function(){
                runs(function(){
                    api.dosync(false, "", okHdlr, errHdlr);
                });
                waitsForSpies([okHdlr, errHdlr], 'dosync timeout', 1000);
                runs(function(){
                    expect(errHdlr).not.toHaveBeenCalled();
                    if(0 < errHdlr.callCount) jasmine.log('errHdlr called with: ' +errHdlr.mostRecentCall.args);
                    expect(okHdlr).toHaveBeenCalled();
                    if (0 < okHdlr.callCount) {
                        jasmine.log('result is ' +okHdlr.mostRecentCall.args[0]);
                        expect("ok" == okHdlr.mostRecentCall.args[0]).toBeTruthy();
                    }
                });
            });

            it("should be able to check if sync still in progress", function(){
                runs(function(){
                    jasmine.log('NOTE: We may have sync already finished here');
                    api.is_syncing(okHdlr, errHdlr);
                });
                waitsForSpies([okHdlr, errHdlr], 'is_syncing timeout', 1000);
                runs(function(){
                    expect(errHdlr).not.toHaveBeenCalled();
                    if(0 < errHdlr.callCount) jasmine.log('errHdlr called with: ' +errHdlr.mostRecentCall.args);
                    expect(okHdlr).toHaveBeenCalled();
                    if (0 < okHdlr.callCount) {
                        jasmine.log('result is ' +okHdlr.mostRecentCall.args[0]);
                    }
                });
            });

            it("should be able to stop sync all sources", function(){
                runs(function(){
                    api.stop_sync(okHdlr, errHdlr);
                });
                waitsForSpies([okHdlr, errHdlr], 'stop_sync timeout', 1000);
                runs(function(){
                    expect(errHdlr).not.toHaveBeenCalled();
                    if(0 < errHdlr.callCount) jasmine.log('errHdlr called with: ' +errHdlr.mostRecentCall.args);
                    expect(okHdlr).toHaveBeenCalled();
                    if (0 < okHdlr.callCount) {
                        jasmine.log('result is ' +okHdlr.mostRecentCall.args[0]);
                        expect("ok" == okHdlr.mostRecentCall.args[0]).toBeTruthy();
                    }
                });
                /*
                runs(function(){
                    api.is_syncing(okHdlr, errHdlr);
                });
                waitsForSpies([okHdlr, errHdlr], 'is_syncing timeout', 1000);
                runs(function(){
                    expect(errHdlr).not.toHaveBeenCalled();
                    if(0 < errHdlr.callCount) jasmine.log('errHdlr called with: ' +errHdlr.mostRecentCall.args);
                    expect(okHdlr).toHaveBeenCalled();
                    if (0 < okHdlr.callCount) {
                        jasmine.log('result is ' +okHdlr.mostRecentCall.args[0]);
                        expect("false" == okHdlr.mostRecentCall.args[0]).toBeTruthy();
                    }
                });
                */
            });

            it("should sync exact source", function(){
                runs(function(){
                    api.dosync_source("Metadata", false, "", okHdlr, errHdlr);
                });
                waitsForSpies([okHdlr, errHdlr], 'dosync_source timeout', 1000);
                runs(function(){
                    expect(errHdlr).not.toHaveBeenCalled();
                    if(0 < errHdlr.callCount) jasmine.log('errHdlr called with: ' +errHdlr.mostRecentCall.args);
                    expect(okHdlr).toHaveBeenCalled();
                    if (0 < okHdlr.callCount) {
                        jasmine.log('result is ' +okHdlr.mostRecentCall.args[0]);
                        expect("ok" == okHdlr.mostRecentCall.args[0]).toBeTruthy();
                    }
                });
            });

            it("should be able to stop source sync", function(){
                runs(function(){
                    api.stop_sync(okHdlr, errHdlr);
                });
                waitsForSpies([okHdlr, errHdlr], 'stop_sync timeout', 1000);
                runs(function(){
                    expect(errHdlr).not.toHaveBeenCalled();
                    if(0 < errHdlr.callCount) jasmine.log('errHdlr called with: ' +errHdlr.mostRecentCall.args);
                    expect(okHdlr).toHaveBeenCalled();
                    if (0 < okHdlr.callCount) {
                        jasmine.log('result is ' +okHdlr.mostRecentCall.args[0]);
                        expect("ok" == okHdlr.mostRecentCall.args[0]).toBeTruthy();
                    }
                });
                /*
                runs(function(){
                    api.is_syncing(okHdlr, errHdlr);
                });
                waitsForSpies([okHdlr, errHdlr], 'is_syncing timeout', 1000);
                runs(function(){
                    expect(errHdlr).not.toHaveBeenCalled();
                    if(0 < errHdlr.callCount) jasmine.log('errHdlr called with: ' +errHdlr.mostRecentCall.args);
                    expect(okHdlr).toHaveBeenCalled();
                    if (0 < okHdlr.callCount) {
                        jasmine.log('result is ' +okHdlr.mostRecentCall.args[0]);
                        expect("false" == okHdlr.mostRecentCall.args[0]).toBeTruthy();
                    }
                });
                */
            });

        });

        it("should logout ok", function(){
            runs(function(){
                api.logout(okHdlr, errHdlr);
            });
            waitsForSpies([okHdlr, errHdlr], 'logout timeout', 1000);
            runs(function(){
                expect(errHdlr).not.toHaveBeenCalled();
                if(0 < errHdlr.callCount) jasmine.log('errHdlr called with: ' +errHdlr.mostRecentCall.args);
                expect(okHdlr).toHaveBeenCalled();
                if (0 < okHdlr.callCount) {
                    jasmine.log('result is ' +okHdlr.mostRecentCall.args[0]);
                    expect("ok" == okHdlr.mostRecentCall.args[0]).toBeTruthy();
                }
            });
            runs(function(){
                api.logged_in(okHdlr, errHdlr);
            });
            waitsForSpies([okHdlr, errHdlr], 'logged_in timeout', 1000);
            runs(function(){
                expect(errHdlr).not.toHaveBeenCalled();
                if(0 < errHdlr.callCount) jasmine.log('errHdlr called with: ' +errHdlr.mostRecentCall.args);
                expect(okHdlr).toHaveBeenCalled();
                if (0 < okHdlr.callCount) {
                    jasmine.log('result is ' +okHdlr.mostRecentCall.args[0]);
                    expect("false" == okHdlr.mostRecentCall.args[0]).toBeTruthy();
                }
            });
        });
    });

});
