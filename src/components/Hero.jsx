// src/components/Hero.jsx
import defaultAvatar from '../assets/images/Zack_de_Boer.jpg';

export const Hero = ({ name, title, bio, avatarUrl }) => (
  <section className="hero-container">
    <div className="hero-content">
      <div className="hero-text">
        <span className="hero-badge">Available for Work</span>
        <h1>{name}</h1>
        <h2 className="hero-title-gradient">{title}</h2>
        <p className="hero-bio">{bio}</p>
        <div className="hero-cta">
          <a href="#work" className="btn-primary">
            View My Work
          </a>
          <a href="https://github.com/zdeboer" className="btn-secondary">
            GitHub
          </a>
        </div>
      </div>
      <div className="hero-image-wrapper">
        <img src={avatarUrl ? avatarUrl : defaultAvatar} alt={name} className="hero-avatar" />
      </div>
    </div>
  </section>
);
