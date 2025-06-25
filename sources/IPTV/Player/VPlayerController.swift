//
//  PlayerController.swift
//  IPTV
//
//  Created by Tarik ALAOUI on 10/11/2024.
//

import UIKit
#if os(tvOS)
import TVVLCKit
#endif
#if os(iOS)
import GoogleCast
import MobileVLCKit
#endif

import FontAwesome
import IPTVModels

class VPlayerController: UIViewController, VLCMediaPlayerDelegate, ObservableObject {
  var mediaPlayer = VLCMediaPlayer()

  @Published var currentTimeString: String = "00:00"
  @Published var videoLength: Int32 = 100 // setting some positive value to avoid div by zero and NAN exceptions
  @Published var videoCurrentTime: Int32 = 0
  @Published var percentagePlayedSoFar: Float = 0.0
  @Published var videoLengthString: String = "--:--"

  // UI Elements
  private let playPauseButton = UIButton(type: .system)
  private let forwardButton = UIButton(type: .system)
  private let rewindButton = UIButton(type: .system)
  private let closeButton = UIButton(type: .system)
  private let audioTrackButton = UIButton(type: .system)
  private let subtitlesButton = UIButton(type: .system)

  private let progressLabel = UILabel()
  private let videoContainerView = UIView(frame: .zero) // Conteneur pour la vidéo
  private let controlsContainerView = UIView() // Conteneur pour la vidéo
  private let backGround = UIView()
#if os(iOS)
  private let castButton = GCKUICastButton()
  private var sessionManager: GCKSessionManager {
    GCKCastContext.sharedInstance().sessionManager
  }

  private var mediaInformation: GCKMediaInformation?
#endif

  private enum Constants {
    static let fontSize: CGFloat = 14
  }

  private var controlsVisible = true
  private var hideControlsTimer: Timer?

  private var playerTimeChangedNotification: NSObjectProtocol?
  private var playerStateChangedNotification: NSObjectProtocol?

  private var retryCount = 0
  private let maxRetries = 5

  override func viewDidLoad() {
    super.viewDidLoad()
    view.layoutMargins = .zero
    view.backgroundColor = .black
    DispatchQueue.main.async {
      self.setupBackground()
      self.setupPlayer()
      self.setupUI()
      self.setupActions()
      self.showControls()
      self.setupRemoteInteraction()
#if os(iOS)
      self.sessionManager.add(self)
#endif
    }
    playerStateChangedNotification = NotificationCenter.default.addObserver(
      forName: Notification.Name(rawValue: VLCMediaPlayerStateChanged),
      object: mediaPlayer,
      queue: nil,
      using: playerStateChanged
    )

    playerTimeChangedNotification = NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: VLCMediaPlayerTimeChanged), object: mediaPlayer, queue: nil, using: playerTimeChanged)
  }

  func setupPlayer(with mediaURL: URL, id _: Int, kind _: KindMedia) {
    let media = VLCMedia(url: mediaURL)
    media.addOptions([
      "file-caching": "3000",
      "live-caching": "1000",
      "network-caching": "3000",
      "http-reconnect": "1",
      "rtsp-caching": "3000",

    ])
    print(mediaURL)
    DispatchQueue.main.async { [weak self] in
      self?.mediaPlayer.media = media
      self?.mediaPlayer.play()
      self?.mediaPlayer.perform(Selector(("setTextRendererFontSize:")), with: Constants.fontSize)
    }

    // setupMediaCast(mediaURL: mediaURL, id: id, kind: kind)
  }

  func mediaPlayerStateChanged(_: Notification) {
    DispatchQueue.main.async { [weak self] in
      guard let self else { return }

      switch mediaPlayer.state {
      case .stopped:
        print("Lecture arrêtée.")
      case .ended:
        print("Lecture terminée.")
      case .error:
        print("Erreur détectée, tentative de relance...")
        retryPlayback()
      default:
        break
      }
    }
  }

  private func retryPlayback() {
    guard retryCount < maxRetries else {
      print("Nombre maximum de tentatives atteint.")
      return
    }

    retryCount += 1
    guard let media = mediaPlayer.media else {
      print("Aucun média disponible pour relancer la lecture.")
      return
    }

    mediaPlayer.stop()
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
      self?.mediaPlayer.media = media
      self?.mediaPlayer.play()
    }
  }

  override func viewWillDisappear(_: Bool) {
    unregisterObservers()
  }

  deinit {
    if mediaPlayer.isPlaying {
      mediaPlayer.stop()
      mediaPlayer.media = nil
      mediaPlayer.drawable = nil
    }
  }

  func playerStateChanged(_: Notification) {
    videoLength = mediaPlayer.media!.length.intValue
    videoLengthString = mediaPlayer.media!.length.stringValue
  }

  func playerTimeChanged(_: Notification) {
    currentTimeString = mediaPlayer.time.stringValue
    videoCurrentTime = mediaPlayer.time.intValue
    percentagePlayedSoFar = Float(videoCurrentTime) / Float(videoLength)

    DispatchQueue.main.async { [weak self] in
      self?.progressLabel.text = String(format: "%@ / %@", self?.currentTimeString ?? "00:00", self?.videoLengthString ?? "00:00")
    }
  }

  func unregisterObservers() {
    NotificationCenter.default.removeObserver(playerTimeChangedNotification as Any)
    NotificationCenter.default.removeObserver(playerStateChangedNotification as Any)
  }

  private func setupBackground() {
    view.addSubview(backGround)
    backGround.translatesAutoresizingMaskIntoConstraints = false
    backGround.backgroundColor = .black
    backGround.isUserInteractionEnabled = false
    NSLayoutConstraint.activate([
      backGround.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      backGround.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      backGround.topAnchor.constraint(equalTo: view.topAnchor),
      backGround.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])
  }

  // MARK: - Player Setup

  private func setupPlayer() {
    videoContainerView.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(videoContainerView)
    controlsContainerView.backgroundColor = .black.withAlphaComponent(0.4)
    controlsContainerView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(controlsContainerView)

    mediaPlayer.setDeinterlaceFilter(nil)
    mediaPlayer.drawable = videoContainerView
    mediaPlayer.delegate = self

    NSLayoutConstraint.activate([
      videoContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
      videoContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
      videoContainerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
      videoContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
    ])
    videoContainerView.isUserInteractionEnabled = false
    videoContainerView.coverWholeSuperview()

    NSLayoutConstraint.activate([
      controlsContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      controlsContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      controlsContainerView.topAnchor.constraint(equalTo: view.topAnchor),
      controlsContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])
    controlsContainerView.isUserInteractionEnabled = true
  }

#if os(iOS)
  private func setupMediaCast(mediaURL: URL, id: Int, kind _: KindMedia) {
    GCKCastContext.sharedInstance().presentDefaultExpandedMediaControls()

    var metadata = GCKMediaMetadata()
    metadata.setString("Big Buck Bunny (2008)", forKey: kGCKMetadataKeyTitle)
    metadata.setString(
      "Big Buck Bunny tells the story of a giant rabbit with a heart bigger than " +
        "himself. When one sunny day three rodents rudely harass him, something " +
        "snaps... and the rabbit ain't no bunny anymore! In the typical cartoon " +
        "tradition he prepares the nasty rodents a comical revenge.",
      forKey: kGCKMetadataKeySubtitle
    )
    metadata.addImage(GCKImage(
      url: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/BigBuckBunny.jpg")!,
      width: 480,
      height: 360
    ))

    /* Loading media to cast by creating a media request */
    let mediaInfoBuilder = GCKMediaInformationBuilder(contentURL: mediaURL)
    mediaInfoBuilder.contentID = String(id)
    mediaInfoBuilder.streamType = GCKMediaStreamType.none
    // mediaInfoBuilder.contentType = "video/mp4"
    mediaInfoBuilder.metadata = metadata
    mediaInformation = mediaInfoBuilder.build()

    /* Configuring the media request */
    let mediaLoadRequestDataBuilder = GCKMediaLoadRequestDataBuilder()
    mediaLoadRequestDataBuilder.mediaInformation = mediaInformation

    if let request = sessionManager.currentSession?.remoteMediaClient?.loadMedia(with: mediaLoadRequestDataBuilder.build()) {
      request.delegate = self
    }
  }
#endif

  // MARK: - UI Setup

  private func setupUI() {
    closeButton.setImage(UIImage(systemName: "arrowshape.turn.up.backward.fill"), for: .normal)
    closeButton.alpha = 1
    closeButton.tintColor = .white

    playPauseButton.setImage(UIImage.fontAwesomeIcon(name: .pause, style: .solid, textColor: .white, size: CGSize(width: 32, height: 32)), for: .normal)
    playPauseButton.alpha = 1
    playPauseButton.tintColor = .white
    forwardButton.setImage(UIImage.fontAwesomeIcon(name: .forward, style: .solid, textColor: .white, size: CGSize(width: 32, height: 32)), for: .normal)
    forwardButton.setTitle("+ 30s", for: .normal)
    forwardButton.alpha = 1
    forwardButton.tintColor = .white
    rewindButton.setImage(UIImage.fontAwesomeIcon(name: .backward, style: .solid, textColor: .white, size: CGSize(width: 32, height: 32)), for: .normal)
    rewindButton.alpha = 1
    rewindButton.tintColor = .white
    rewindButton.setTitle("- 30s", for: .normal)
#if os(iOS)
    castButton.frame = CGRectMake(0, 0, 24, 24)
    castButton.tintColor = UIColor.gray
#endif
    progressLabel.textAlignment = .center
    progressLabel.text = String(format: "%@ / %@", currentTimeString, videoLengthString)
    progressLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 18, weight: .medium)
    progressLabel.textColor = .white

    // Configure AudioTrackButton
    audioTrackButton.setImage(UIImage(systemName: "mouth.fill"), for: .normal)
    audioTrackButton.tintColor = .white

    // Configure SubtitlesButton
    subtitlesButton.setImage(UIImage(systemName: "globe.badge.chevron.backward"), for: .normal)
    subtitlesButton.tintColor = .white

    let spacer = UIView()

#if os(iOS)
    let stopStack = UIStackView(arrangedSubviews: [closeButton, spacer, castButton, audioTrackButton, subtitlesButton, progressLabel])
#endif
#if os(tvOS)
    let stopStack = UIStackView(arrangedSubviews: [closeButton, spacer, audioTrackButton, subtitlesButton, progressLabel])
#endif

    stopStack.axis = .horizontal
    stopStack.spacing = 30
    stopStack.alignment = .top
    stopStack.translatesAutoresizingMaskIntoConstraints = false

    controlsContainerView.addSubview(stopStack)

    NSLayoutConstraint.activate([
      stopStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      stopStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      stopStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 32),
    ])

    let controlsStack = UIStackView(arrangedSubviews: [rewindButton, playPauseButton, forwardButton])
    controlsStack.axis = .horizontal
    controlsStack.spacing = 30
    controlsStack.alignment = .bottom
    controlsStack.translatesAutoresizingMaskIntoConstraints = false

    controlsContainerView.addSubview(controlsStack)

    // Contrainte de la stack
    NSLayoutConstraint.activate([
      controlsStack.centerXAnchor.constraint(equalTo: controlsContainerView.centerXAnchor),
      controlsStack.bottomAnchor.constraint(equalTo: controlsContainerView.safeAreaLayoutGuide.bottomAnchor, constant: -40),
    ])

    // Afficher les contrôles par défaut
    controlsContainerView.alpha = 1
    view.bringSubviewToFront(controlsContainerView)
  }

  @objc private func selectAudioTrack() {
    guard let audioTracks = mediaPlayer.audioTrackNames as? [String] else { return }

    // Present an action sheet to select an audio track
    let alert = UIAlertController(title: "Select Audio Track", message: nil, preferredStyle: .actionSheet)
    for (index, trackName) in audioTracks.enumerated() {
      alert.addAction(UIAlertAction(title: trackName, style: .default, handler: { _ in
        self.mediaPlayer.currentAudioTrackIndex = Int32(index + 1)
      }))
    }
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    present(alert, animated: true)
  }

  @objc private func toggleSubtitles() {
    guard let subtitleTracks = mediaPlayer.videoSubTitlesNames as? [String] else { return }
    print(subtitleTracks)
    // Present an action sheet to enable/disable subtitles
    let alert = UIAlertController(title: "Subtitles", message: nil, preferredStyle: .actionSheet)
    alert.addAction(UIAlertAction(title: "Disable", style: .default, handler: { _ in
      self.mediaPlayer.currentVideoSubTitleIndex = -1
    }))
    for (index, trackName) in subtitleTracks.enumerated() {
      alert.addAction(UIAlertAction(title: trackName, style: .default, handler: { _ in
        self.mediaPlayer.currentVideoSubTitleIndex = Int32(index + 1)
      }))
    }
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    present(alert, animated: true)
  }

  private func setupActions() {
    playPauseButton.addTarget(self, action: #selector(togglePlayPause), for: .primaryActionTriggered)
    forwardButton.addTarget(self, action: #selector(skipForward), for: .primaryActionTriggered)
    rewindButton.addTarget(self, action: #selector(skipBackward), for: .primaryActionTriggered)
    closeButton.addTarget(self, action: #selector(closeView), for: .primaryActionTriggered)
    audioTrackButton.addTarget(self, action: #selector(selectAudioTrack), for: .primaryActionTriggered)
    subtitlesButton.addTarget(self, action: #selector(toggleSubtitles), for: .primaryActionTriggered)
  }

  @objc
  private func closeView() {
    if mediaPlayer.isPlaying {
      mediaPlayer.stop()
    }
    dismiss(animated: true)
  }

  // MARK: - Show/Hide Controls

  private func showControls() {
    controlsVisible = true
    UIView.animate(withDuration: 0.3) {
      self.controlsContainerView.alpha = 1
      self.playPauseButton.alpha = 1
      self.forwardButton.alpha = 1
      self.rewindButton.alpha = 1

      if self.mediaPlayer.videoSubTitlesNames.isEmpty {
        self.subtitlesButton.alpha = 0
      } else {
        self.subtitlesButton.alpha = 1
      }
      if self.mediaPlayer.videoTrackNames.isEmpty {
        self.audioTrackButton.alpha = 0
      } else {
        self.audioTrackButton.alpha = 1
      }
    }
    resetHideControlsTimer()
  }

  private func hideControls() {
    controlsVisible = false
    UIView.animate(withDuration: 0.3) {
      self.controlsContainerView.alpha = 0
      self.playPauseButton.alpha = 0
      self.forwardButton.alpha = 0
      self.rewindButton.alpha = 0
    }
  }

  private func setupRemoteInteraction() {
#if os(iOS)
    // Gestion des interactions tactiles sur iOS/iPadOS
    let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(remoteInteraction))
    tapRecognizer.numberOfTapsRequired = 1
    tapRecognizer.cancelsTouchesInView = false
    videoContainerView.isUserInteractionEnabled = true
    videoContainerView.addGestureRecognizer(tapRecognizer)
#endif

#if os(tvOS)
    // Gestion des actions avec la télécommande sur tvOS
    let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(remoteInteraction))
    tapRecognizer.allowedPressTypes = [
      NSNumber(value: UIPress.PressType.select.rawValue),
      NSNumber(value: UIPress.PressType.playPause.rawValue),
    ]
    view.isUserInteractionEnabled = true
    view.addGestureRecognizer(tapRecognizer)
#endif
  }

  @objc private func remoteInteraction() {
    print("tap detected \(controlsVisible)")
    if !controlsVisible {
      showControls()
    } else {
      hideControls()
    }
  }

  // MARK: - Player Actions

  @objc private func togglePlayPause() {
    if mediaPlayer.isPlaying {
      mediaPlayer.pause()
      playPauseButton.setImage(UIImage.fontAwesomeIcon(name: .play, style: .solid, textColor: .white, size: CGSize(width: 32, height: 32)), for: .normal)
      playPauseButton.alpha = 1
      playPauseButton.tintColor = .white
    } else {
      mediaPlayer.play()
      playPauseButton.setImage(UIImage.fontAwesomeIcon(name: .pause, style: .solid, textColor: .white, size: CGSize(width: 32, height: 32)), for: .normal)
      playPauseButton.alpha = 1
      playPauseButton.tintColor = .white
    }
    resetHideControlsTimer()
  }

  @objc private func skipForward() {
    let currentTime = mediaPlayer.time.intValue
    guard let length = mediaPlayer.media?.length.intValue else { return }
    let newTime = min(currentTime + 30000, length) // Skip forward by 10 seconds
    mediaPlayer.time = VLCTime(int: newTime)
    resetHideControlsTimer()
  }

  @objc private func skipBackward() {
    let currentTime = mediaPlayer.time.intValue
    let newTime = max(currentTime - 30000, 0) // Skip backward by 10 seconds
    mediaPlayer.time = VLCTime(int: newTime)
    resetHideControlsTimer()
  }

  private func resetHideControlsTimer() {
    hideControlsTimer?.invalidate()
    hideControlsTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { [weak self] _ in
      self?.hideControls()
    }
  }
}

#if os(iOS)
extension VPlayerController: GCKSessionManagerListener, GCKRemoteMediaClientListener, GCKRequestDelegate {
  // MARK: - GCKSessionManagerListener

  func sessionManager(_: GCKSessionManager, didStart session: GCKSession) {
    print("MediaViewController: sessionManager didStartSession \(session)")
    sessionManager.currentSession?.remoteMediaClient?.add(self)
  }

  func sessionManager(_: GCKSessionManager, didResumeSession session: GCKSession) {
    print("MediaViewController: sessionManager didResumeSession \(session)")
    sessionManager.currentSession?.remoteMediaClient?.add(self)
  }

  func sessionManager(_: GCKSessionManager, didEnd _: GCKSession, withError error: Error?) {
    print("session ended with error: \(String(describing: error))")
    let message = "The Casting session has ended.\n\(String(describing: error))"
    sessionManager.currentSession?.remoteMediaClient?.remove(self)
  }

  func sessionManager(_: GCKSessionManager, didFailToStartSessionWithError _: Error?) {
    sessionManager.currentSession?.remoteMediaClient?.remove(self)
  }

  func sessionManager(
    _: GCKSessionManager,
    didFailToResumeSession _: GCKSession,
    withError _: Error?
  ) {
    sessionManager.currentSession?.remoteMediaClient?.remove(self)
  }

  func remoteMediaClient(_: GCKRemoteMediaClient, didUpdate mediaStatus: GCKMediaStatus?) {
    if let mediaStatus {
      mediaInformation = mediaStatus.mediaInformation
    }
  }

  // MARK: - GCKRequestDelegate

  func requestDidComplete(_ request: GCKRequest) {
    print("request \(Int(request.requestID)) completed")
  }

  func request(_ request: GCKRequest, didFailWithError error: GCKError) {
    print("request \(Int(request.requestID)) failed with error \(error)")
  }
}
#endif
