// src/components/Hero.jsx
export const Hero = ({ name, title, bio }) => (
  <header className="hero-section">
    <h1>{name}</h1>
    <p className="subtitle">{title}</p>
    <p className="bio">{bio}</p>
  </header>
);
