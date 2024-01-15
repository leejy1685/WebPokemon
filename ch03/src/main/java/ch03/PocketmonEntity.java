package 웹프기말_포켓몬;

import java.util.*;

public class PocketmonEntity {
	int id; //포켓몬 번호
	String name; //포켓몬 이름
	String property; //속성
	int HP; //체력
	int STR; //공격력
	int DEX; //방어력
	
	private List<SkillEntity> skills; // 스킬 리스트 필드 추가

    // 스킬 리스트에 대한 getter와 setter
    public List<SkillEntity> getSkills() {
        return skills;
    }

    public void setSkills(List<SkillEntity> skills,PocketmonEntity pocketmon) {
    	Random rand = new Random();
    	if ("노말".equals(pocketmon.getProperty())) {
    		 Collections.shuffle(skills, rand); 
    		 if (skills.size() > 4) {
    			 skills = skills.subList(0, 4);
    		 }
    		 this.skills=skills;
    	}

        this.skills = skills;
    }
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getProperty() {
		return property;
	}
	public void setProperty(String property) {
		this.property = property;
	}
	public int getHP() {
		return HP;
	}
	public void setHP(int hP) {
		HP = hP;
	}
	public int getSTR() {
		return STR;
	}
	public void setSTR(int sTR) {
		STR = sTR;
	}
	public int getDEX() {
		return DEX;
	}
	public void setDEX(int dEX) {
		DEX = dEX;
	}
}
