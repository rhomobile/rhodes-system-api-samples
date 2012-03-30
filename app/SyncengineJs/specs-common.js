// "http://rhodes-store-server.heroku.com/application";

function waitsForSpies(spy, msg, timeout) {
    timeout = timeout || 1000;
    var spies = $.isArray(spy) ? spy : [spy];
    for(var i in spies) {
        spies[i].refCallCount = spies[i].refCallCount || 0;
        //jasmine.log(spies[i].identity +': ' +spies[i].refCallCount.toString() +' = ' +spies[i].callCount.toString());
    }
    waitsFor(function(){
        for (var i in spies) {
            //jasmine.log(spies[i].identity +': ' +spies[i].refCallCount.toString() +' <? ' +spies[i].callCount.toString());
            if (spies[i].refCallCount < spies[i].callCount) {
                spies[i].refCallCount = spies[i].callCount;
                return true;
            }
        }
        return false;
    }, msg, timeout);
}

function testSetGetValue(items, timeout) {
    $.each(items, function(idx, item){
        $.each(item.values, function(idx, value){
            var okHdlr = jasmine.createSpy('for ok');
            var errHdlr = jasmine.createSpy('for errors');

            it(item.label, function(){
                runs(function(){
                    jasmine.log('set value to ' +value);
                    api[item.funcNameSet](value, okHdlr, errHdlr);
                });
                waitsForSpies([okHdlr, errHdlr], item.funcNameSet +' timeout', timeout);
                runs(function(){
                    expect(errHdlr).not.toHaveBeenCalled();
                    if(0 < errHdlr.callCount) jasmine.log('errHdlr called with: ' +errHdlr.mostRecentCall.args);
                    expect(okHdlr).toHaveBeenCalled();
                    if (0 < okHdlr.callCount) {
                        jasmine.log('result is ' +okHdlr.mostRecentCall.args[0]);
                        expect(
                            item.resultTest.apply(this, [okHdlr.mostRecentCall.args[0]])
                        ).toBeTruthy();
                    }
                });

                if (item.funcNameGet) {
                    runs(function(){
                        jasmine.log('read value');
                        api[item.funcNameGet](okHdlr, errHdlr);
                    });
                    waitsForSpies([okHdlr, errHdlr], item.funcNameGet +' timeout', timeout);
                    runs(function(){
                        expect(errHdlr).not.toHaveBeenCalled();
                        if(0 < errHdlr.callCount) jasmine.log('errHdlr called with: ' +errHdlr.mostRecentCall.args);
                        expect(okHdlr).toHaveBeenCalled();
                        if (0 < okHdlr.callCount) {
                            jasmine.log('result is ' +okHdlr.mostRecentCall.args[0]);
                            expect(
                                item.resultTest.apply(this, [okHdlr.mostRecentCall.args[0], value])
                            ).toBeTruthy();
                        }
                    });
                }
            });

        });
    });
}

function testIsOk(items, timeout) {
    $.each(items, function(idx, item){
        var okHdlr = jasmine.createSpy('for ok');
        var errHdlr = jasmine.createSpy('for errors');

        it(item.label, function(){
            runs(function(){
                api[item.funcName](okHdlr, errHdlr);
            });
            waitsForSpies([okHdlr, errHdlr], item.funcName +' timeout', timeout);
            runs(function(){
                expect(errHdlr).not.toHaveBeenCalled();
                if(0 < errHdlr.callCount) jasmine.log('errHdlr called with: ' +errHdlr.mostRecentCall.args);
                expect(okHdlr).toHaveBeenCalled();
                if (0 < okHdlr.callCount) {
                    jasmine.log('result is ' +okHdlr.mostRecentCall.args[0]);
                    expect(
                        resultIsOk(okHdlr.mostRecentCall.args[0])
                    ).toBeTruthy();
                }
            });
        });
    });
}

function resultIsNumber(result, value) {
    return (
        "string" == typeof result
            && result.match(/[0-9]+/)
            && ('undefined' == typeof value || parseInt(result) == value)
        );
}

function resultIsOk(result, value) {
    return "ok" == result;
}

beforeEach(function() {

    this.addMatchers({
        toBeSet: function(descr) {
            return (undefined != this.actual && null != this.actual
                && this.actual == this.actual /* (NaN == NaN) is always false */);
        }
    });

    userlogin = "testUserToFailAuth";
    userpass = "userpass";
    wrongpass = "wrongpass";

    api = window.Rho.syncengine;

//    notified = false;
//    notify = function(evt, obj){
//        jasmine.log(evt.type + ': ' + $.toJSON(obj));
//        notified = true;
//    };


});
