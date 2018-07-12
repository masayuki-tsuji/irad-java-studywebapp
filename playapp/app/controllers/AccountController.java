package controllers;

import play.mvc.*;
import play.data.*;

import models.*;

import javax.inject.*;
import play.Logger;

public class AccountController extends Controller {
    private final FormFactory formFactory;
    
    @Inject
    public AccountController(final FormFactory formFactory) {
        // フォーム作成用ファクトリーの作成
        this.formFactory = formFactory;
    }

    public Result input() {
        return ok(views.html.accounts.input.render(formFactory.form(Accounts.class)));
    }
}
