package models;

import io.ebean.*;
import javax.persistence.Entity;
import javax.persistence.Id;

@Entity
public class Accounts extends Model {
    // id
    @Id
    public Long id;
    // 名前
    public String name;
    // 検索用変数
    public static final Finder<Long, Accounts> find = new Finder<>(Accounts.class);
}