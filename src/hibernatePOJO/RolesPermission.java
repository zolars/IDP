package hibernatePOJO;

import javax.persistence.*;
import java.util.Objects;

@Entity
@Table(name = "roles_permission", schema = "test", catalog = "")
public class RolesPermission {
    private String rid;
    private String pid;

    @Id
    @Column(name = "rid", nullable = false, length = 255)
    public String getRid() {
        return rid;
    }

    public void setRid(String rid) {
        this.rid = rid;
    }

    @Basic
    @Column(name = "pid", nullable = true, length = 255)
    public String getPid() {
        return pid;
    }

    public void setPid(String pid) {
        this.pid = pid;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        RolesPermission that = (RolesPermission) o;
        return Objects.equals(rid, that.rid) &&
                Objects.equals(pid, that.pid);
    }

    @Override
    public int hashCode() {

        return Objects.hash(rid, pid);
    }
}
