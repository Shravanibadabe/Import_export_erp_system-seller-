package model;

public class User {
    private String portId;
    private String name;
    private String email;
    private String password;
    private String location;

    public String getPortId() { return portId; }
    public void setPortId(String portId) { this.portId = portId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }
}
