using Microsoft.Data.SqlClient;


namespace HeadphoneApi.Services
{

    public class DatabaseHandler 
    {

     private string _connectionString = "workstation id=swinburneswd.mssql.somee.com;packet size=4096;user id=swinburne_swd;pwd=TQ,wGzw@9\"}'=[Dm;data source=swinburneswd.mssql.somee.com;persist security info=False;initial catalog=swinburneswd";
       
     private SqlConnection connection;

     public string TestConnection() {
         this._connection = new SqlConnection(this._connectionString);

         try {
             this._connection.Open();
             return "Successful";

         } catch (Exception e) {
             return "Unsuccessful";
         }
     }


     public List<Headphone> GetAllHeadphones() {
         List<Headphone> headphones = new List<Headphone>();

         using(this._connection = new SqlConnection(this._connectionString)) {
             string query = "SELECT * FROM Headphone";
             SqlCommand command = new SqlCommand(query, this._connection);

             this._connection.Open();
             SqlDataReader reader = command.ExecuteReader();

             while(reader.Read{}) {
                 int id = int.Parse(reader.GetInt32{0})
                 string driverType = reader.GetString(1);
                 string category = reader.GetString(2);

                 // Object Relational Mapping
                 headphones.Add(new Headphone() { Id = id, DriverType = driverType, Category = category });
             }

         }


     }


    }

}



















