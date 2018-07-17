package controllers;

import play.mvc.*;
import play.data.*;

import models.*;

import javax.inject.*;
import play.Logger;

import java.util.List;

public class AccountController extends Controller {

    private final FormFactory formFactory;

    @Inject
    public AccountController(final FormFactory formFactory) {
        // フォーム生成ユーティリティ
        this.formFactory = formFactory;
    }

    /**
     * 会員一覧ページを表示する。
     * @return レスポンスデータ
     */
    public Result index() {
        // 一覧データを全て取得する。
        List<Accounts> accounts = Accounts.find.all();
        // list.scala.htmlに取得した一覧データを渡す。
        return ok(views.html.accounts.list.render(accounts));
    }

    /**
     * 会員登録ページを表示する。
     * @return レスポンスデータ
     */
    public Result input() {
        // input.scala.htmlに初期化されたAccountsフォームを渡す。
        return ok(views.html.accounts.input.render(formFactory.form(Accounts.class)));
    }
    
    /**
     * 会員登録処理を実行する。
     * @return レスポンスデータ
     */
    public Result create() {
        // POST送信された会員データを取得する。
        Form<Accounts> userForm = formFactory.form(Accounts.class).bindFromRequest();
        // フォームデータからモデルデータに変換する。
        Accounts user = userForm.get();
        // 会員データを登録する。
        user.save();
        // 会員一覧ページに遷移する。
        return redirect(routes.AccountController.index());
    }
    
    /**
     * 会員一覧ページを表示する
     * @return レスポンスデータ
     */
    public Result edit(final Long id) {
        // 指定したIDの会員データを取得する。
        Accounts account = Accounts.find.byId(id);
        // 初期化されたフォームデータを作成する。
        Form<Accounts> userForm = formFactory.form(Accounts.class);
        // 取得した会員データをフォームデータに紐づけを行う。
        userForm = userForm.fill(account);
        // edit.scala.htmlに会員IDとフォーム
        return ok(views.html.accounts.edit.render(id, userForm));
    }
    
    /**
     * 会員一覧ページを表示する
     * @return レスポンスデータ
     */
    public Result update(final Long id) {
        // POST送信された会員データを取得する。
        Form<Accounts> userForm = formFactory.form(Accounts.class).bindFromRequest();
        // フォームデータからモデルデータに変換する。
        Accounts account = userForm.get();
        // IDを再設定する。
        account.id = id;
        // 既存会員データを更新する。
        account.update();
        // 会員一覧ページに遷移する。
        return redirect(routes.AccountController.index());
    }
    
    /**
     * 特定の会員データを削除する。
     * @return レスポンスデータ
     */
    public Result destroy(final Long id) {
        // 指定したIDの会員データを取得する。
        Accounts account = Accounts.find.byId(id);
        // 会員データを物理削除。
        account.delete();
        // 会員一覧ページに遷移する。
        return redirect(routes.AccountController.index());
    }
}