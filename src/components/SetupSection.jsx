// src/components/SetupSection.jsx
export const SetupSection = ({ editor, terminal, font }) => (
  <div className="setup-container">
    <div className="setup-item">
      <strong>Editor:</strong> {editor}
    </div>
    <div className="setup-item">
      <strong>Terminal:</strong> {terminal}
    </div>
    <div className="setup-item">
      <strong>Font:</strong> <code>{font}</code>
    </div>
  </div>
);
