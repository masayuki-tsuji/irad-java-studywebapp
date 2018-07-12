package models;

import io.ebean.*;
import javax.persistence.Entity;
import javax.persistence.Id;

@Entity
public class Accounts extends Model {
    @Id
    public Long id;
    
    public String name;
    
    public String address;
    
    public boolean status;
}