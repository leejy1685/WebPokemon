package 웹프기말_포켓몬;

import java.sql.*; 
import javax.sql.DataSource; 
import javax.naming.InitialContext;
import java.util.*;

public class PocketmonDBCP {

	// 데이터베이스 연결관련 변수 선언
		private Connection con = null;
		private PreparedStatement pstmt = null;
		private DataSource ds = null;

		// 등록한 DBCP 데이터소스 찾아 저장하는 생성자
		public PocketmonDBCP() {
			try {
				InitialContext ctx = new InitialContext();
			    ds = (DataSource) ctx.lookup("java:comp/env/jdbc/mysql");
			} catch (Exception e) {
				e.printStackTrace();
			}		
		}
		
	// 데이터소스를 통해 데이터베이스에 연결, Connection 객체에 저장하는 메소드 
	void connect() {
		try {
		    con = ds.getConnection();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
		
		// 데이터베이스 연결 해제 메소드 
		void disconnect() {
			if(pstmt != null) {
				try {
					pstmt.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			} 
			if(con != null) {
				try {
					con.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
		}
		
		// 포켓몬 이름으로 레코드를 반환하는 메서드
	public PocketmonEntity getPocketmon(String name) {	
		connect();
		String SQL = "select * from Pocketmon where Name = ?";
		PocketmonEntity pocketmon = new PocketmonEntity();

		try {
			pstmt = con.prepareStatement(SQL);
			pstmt.setString(1, name);
			ResultSet rs = pstmt.executeQuery();			
			if(rs.next()) { //쿼리에 값이 있으면 이렇게 set시킴
				pocketmon.setId ( rs.getInt("Number") );
				pocketmon.setName ( rs.getString("Name") );
				pocketmon.setProperty ( rs.getString("property") );
				pocketmon.setHP ( rs.getInt("HP") );
				pocketmon.setSTR ( rs.getInt("STR") );
				pocketmon.setDEX ( rs.getInt("DEX") );
				return pocketmon;
			}
			rs.close();			
			} catch (SQLException e) {
				e.printStackTrace();
			} 
			finally {
				disconnect();
			}
		return null;
	}
	
	
	public SkillEntity getSkill(String name) {	
		connect();
		String SQL = "SELECT * FROM Skill WHERE Property = (SELECT Property FROM Pocketmon WHERE Name = ?)";
		SkillEntity skill = new SkillEntity();

		try {
			pstmt = con.prepareStatement(SQL);
			pstmt.setString(1, name);
			ResultSet rs = pstmt.executeQuery();			
			if(rs.next()) { //쿼리에 값이 있으면 이렇게 set시킴
				skill.setNum ( rs.getInt("Number") );
				skill.setSkillName ( rs.getString("Name") );
				skill.setProperty ( rs.getString("property") );
				skill.setPower ( rs.getInt("power") );
				skill.setAccuracy ( rs.getInt("Accuracy") );
				return skill;
			}
			rs.close();			
			} catch (SQLException e) {
				e.printStackTrace();
			} 
			finally {
				disconnect();
			}
		return null;
	}
	
	// 포켓몬 이름으로 해당 속성의 모든 스킬을 검색해서 리스트로 반환하는 메서드
    public List<SkillEntity> getSkillsByPokemonName(String pokemonName) {
        List<SkillEntity> skills = new ArrayList<>();
        connect();
        
        String SQL = "SELECT DISTINCT * FROM Skill WHERE Skill.Property IN(SELECT Property FROM Pocketmon WHERE Name = ?)";
        
        try {
            pstmt = con.prepareStatement(SQL);
            pstmt.setString(1, pokemonName);
            ResultSet rs = pstmt.executeQuery();
            
            while(rs.next()) {
                SkillEntity skill = new SkillEntity();
                skill.setNum(rs.getInt("Number"));
                skill.setSkillName(rs.getString("Name"));
                skill.setProperty(rs.getString("Property"));
                skill.setPower(rs.getInt("Power"));
                skill.setAccuracy(rs.getInt("Accuracy"));
                skills.add(skill);
            }
            rs.close();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            disconnect();
        }
        return skills;
    }
    
 //랜덤포켓몬 추출을 위해 모든 포켓몬을 가져오는 메소드
    public List<PocketmonEntity> getRandomPocketmon() {
        List<PocketmonEntity> RandomPocketmon = new ArrayList<>();
        connect();
        
        String SQL = "SELECT DISTINCT * FROM Pocketmon";
        try {
            pstmt = con.prepareStatement(SQL);
            ResultSet rs = pstmt.executeQuery();
            
            while(rs.next()) {
            	PocketmonEntity Pocketmon = new PocketmonEntity();
            	Pocketmon.setId ( rs.getInt("Number") );
            	Pocketmon.setName ( rs.getString("Name") );
            	Pocketmon.setProperty ( rs.getString("property") );
            	Pocketmon.setHP ( rs.getInt("HP") );
            	Pocketmon.setSTR ( rs.getInt("STR") );
            	Pocketmon.setDEX ( rs.getInt("DEX") );
            	RandomPocketmon.add(Pocketmon);
            }
            rs.close();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            disconnect();
        }
        return RandomPocketmon;
    }
    
    
    public boolean checkID(String id, String passwd) {
        connect(); // 데이터베이스 연결
        String sql = "SELECT * FROM User WHERE ID=? AND Password=?";
        try (PreparedStatement pstmt = con.prepareStatement(sql)) {
            pstmt.setString(1, id);
            pstmt.setString(2, passwd);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                // 일치하는 사용자가 있는 경우
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            disconnect(); // 데이터베이스 연결 해제
        }
        // 일치하는 사용자가 없는 경우
        return false;
    }
    
    public void insertUser(String id, String passwd) {
    	connect(); // 데이터베이스 연결

        // SQL to insert a new user
        String sql = "INSERT INTO User (ID, Password) VALUES (?, ?)";

        try (PreparedStatement pstmt = con.prepareStatement(sql)) {
            pstmt.setString(1, id);
            pstmt.setString(2, passwd);
            
            int affectedRows = pstmt.executeUpdate();

            // Optionally, you can still check if the insertion was successful
            if (affectedRows > 0) {
                System.out.println("User successfully inserted.");
            } else {
                System.out.println("No user was inserted.");
            }

            // Check if the insertion was successful
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            disconnect(); // 데이터베이스 연결 해제
        }

    }
		
}
