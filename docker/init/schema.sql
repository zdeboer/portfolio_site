-- Creates the DB + tables your PHP expects.
-- Safe to run multiple times.

CREATE DATABASE IF NOT EXISTS `music`
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE `music`;

-- USERS
CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(50) NOT NULL UNIQUE,
  email VARCHAR(255) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  role VARCHAR(20) NOT NULL DEFAULT 'listener',
  joined_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- PLAYLISTS
CREATE TABLE IF NOT EXISTS playlists (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  name VARCHAR(100) NOT NULL,
  description VARCHAR(255) NOT NULL,
  image VARCHAR(255) NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_playlists_user
    FOREIGN KEY (user_id) REFERENCES users(id)
    ON DELETE CASCADE
) ENGINE=InnoDB;

-- PLAYLIST TRACKS
-- Your code inserts added_by, but also reads user_id in one place.
-- To keep both working without changing PHP, include BOTH columns and sync them.
CREATE TABLE IF NOT EXISTS playlist_tracks (
  id INT AUTO_INCREMENT PRIMARY KEY,
  playlist_id INT NOT NULL,
  spotify_track_id VARCHAR(64) NOT NULL,
  title VARCHAR(255) NOT NULL,
  artist VARCHAR(255) NOT NULL,
  album_image VARCHAR(500) NULL,
  genre VARCHAR(255) NULL,
  added_by INT NOT NULL,
  user_id INT NULL,
  added_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

  INDEX idx_playlist_tracks_playlist_id (playlist_id),
  INDEX idx_playlist_tracks_spotify_track_id (spotify_track_id),
  INDEX idx_playlist_tracks_added_by (added_by),

  CONSTRAINT fk_tracks_playlist
    FOREIGN KEY (playlist_id) REFERENCES playlists(id)
    ON DELETE CASCADE,

  CONSTRAINT fk_tracks_added_by_user
    FOREIGN KEY (added_by) REFERENCES users(id)
    ON DELETE CASCADE
) ENGINE=InnoDB;

DROP TRIGGER IF EXISTS playlist_tracks_set_user_id;
DELIMITER //
CREATE TRIGGER playlist_tracks_set_user_id
BEFORE INSERT ON playlist_tracks
FOR EACH ROW
BEGIN
  IF NEW.user_id IS NULL THEN
    SET NEW.user_id = NEW.added_by;
  END IF;
END//
DELIMITER ;

-- COMMENTS
CREATE TABLE IF NOT EXISTS comments (
  id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(50) NOT NULL,
  user_id INT NOT NULL,
  playlist_id INT NOT NULL,
  content VARCHAR(255) NOT NULL,
  timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

  INDEX idx_comments_playlist_id (playlist_id),
  INDEX idx_comments_user_id (user_id),

  CONSTRAINT fk_comments_user
    FOREIGN KEY (user_id) REFERENCES users(id)
    ON DELETE CASCADE,

  CONSTRAINT fk_comments_playlist
    FOREIGN KEY (playlist_id) REFERENCES playlists(id)
    ON DELETE CASCADE
) ENGINE=InnoDB;