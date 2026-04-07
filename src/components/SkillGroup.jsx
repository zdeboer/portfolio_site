// src/components/SkillGroup.jsx
export const SkillGroup = ({ title, skills }) => (
  <div className="skill-group">
    <h4>{title}</h4>
    <div className="skill-list">
      {skills.map(skill => <span key={skill} className="skill-pill">{skill}</span>)}
    </div>
  </div>
);