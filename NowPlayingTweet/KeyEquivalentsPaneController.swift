/**
 *  KeyEquivalentsPaneController.swift
 *  NowPlayingTweet
 *
 *  © 2018 kPherox.
**/

import Cocoa
import Magnet
import KeyHolder

class KeyEquivalentsPaneController: NSViewController, RecordViewDelegate {

    static let shared: KeyEquivalentsPaneController = {
        let storyboard = NSStoryboard(name: .main, bundle: .main)
        let windowController = storyboard.instantiateController(withIdentifier: .keyEquivalentsPaneController)
        return windowController as! KeyEquivalentsPaneController
    }()

    var userDefaults: UserDefaults = UserDefaults.standard

    let twitterClient: TwitterClient = TwitterClient.shared

    let keyEquivalents: GlobalKeyEquivalents = GlobalKeyEquivalents.shared

    @IBOutlet weak var currentRecordLabel: NSTextField!
    @IBOutlet weak var currentRecortView: RecordView!

    @IBOutlet weak var accountShortcutLabel: NSTextField!

    var selectedRecortView: RecordView?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.

        self.currentRecortView.tintColor = .systemBlue
        self.currentRecortView.cornerRadius = 12
        self.currentRecortView.delegate = self
        self.currentRecortView.identifier = NSUserInterfaceItemIdentifier(rawValue: "Current")
        self.currentRecortView.keyCombo = self.userDefaults.keyCombo(forKey: "Current")

        let existAccount = self.twitterClient.existAccount

        if existAccount {
            self.reloadView()
        }
    }

    override func viewWillAppear() {
        super.viewWillAppear()
        self.reloadView()
    }

    override func cancelOperation(_ sender: Any?) {
        self.selectedRecortView?.endRecording()
    }

    func reloadView() {
        for subview in self.view.subviews {
            switch subview {
            case self.currentRecordLabel, self.currentRecortView, self.accountShortcutLabel:
                continue
            default:
                subview.removeFromSuperview()
            }
        }

        let existAccount = self.twitterClient.existAccount

        self.accountShortcutLabel.isHidden = !existAccount

        let accountRowsHeight = 32 * self.twitterClient.numberOfAccounts
        let frameHeight: CGFloat = CGFloat(existAccount ? 64 + 44 + accountRowsHeight : 64)
        let frameSize: CGSize = CGSize(width: 500, height: frameHeight)

        self.view.setFrameSize(frameSize)
        self.view.window?.setContentSize(frameSize)

        if !existAccount {
            return
        }

        let labelSize = self.currentRecordLabel.frame.size
        let viewSize = self.currentRecortView.frame.size

        let labelXPoint = self.currentRecordLabel.frame.origin.x
        let viewXPoint = self.currentRecortView.frame.origin.x

        var labelYPoint = 28 + accountRowsHeight
        var viewYPoint = 25 + accountRowsHeight

        for accountID in self.twitterClient.accountIDs {
            labelYPoint -= 32
            viewYPoint -= 32
            let labelPoint = CGPoint(x: labelXPoint, y: CGFloat(labelYPoint))
            let viewPoint = CGPoint(x: viewXPoint, y: CGFloat(viewYPoint))

            let labelFrame = CGRect(origin: labelPoint, size: labelSize)
            let viewFrame = CGRect(origin: viewPoint, size: viewSize)

            let accountName: String = self.twitterClient.account(userID: accountID)?.screenName ?? "null"
            let recordLabel: NSTextField = Label(with: "Tweet with @\(accountName):",
                                                 frame: labelFrame,
                                                 alignment: .right) as NSTextField

            let recordView: RecordView = RecordView(frame: viewFrame)
            recordView.tintColor = .systemBlue
            recordView.cornerRadius = 12
            recordView.delegate = self
            recordView.identifier = NSUserInterfaceItemIdentifier(rawValue: accountID)
            recordView.keyCombo = self.userDefaults.keyCombo(forKey: accountID)

            self.view.addSubview(recordLabel)
            self.view.addSubview(recordView)
        }
    }

    func recordViewShouldBeginRecording(_ recordView: RecordView) -> Bool {
        if recordView.identifier == nil { return false }
        recordView.keyCombo = nil
        self.selectedRecortView = recordView
        return true
    }

    func recordView(_ recordView: RecordView, canRecordKeyCombo keyCombo: KeyCombo) -> Bool {
        guard let identifier: String = recordView.identifier?.rawValue else { return false }
        self.keyEquivalents.unregister(identifier)
        return true
    }

    func recordViewDidClearShortcut(_ recordView: RecordView) {
        guard let identifier: String = recordView.identifier?.rawValue else { return }
        self.keyEquivalents.unregister(identifier)
    }

    func recordView(_ recordView: RecordView, didChangeKeyCombo keyCombo: KeyCombo) {
        guard let identifier: String = recordView.identifier?.rawValue else { return }
        self.keyEquivalents.register(identifier, keyCombo: keyCombo)
    }

    func recordViewDidEndRecording(_ recordView: RecordView) {
        self.selectedRecortView = nil
        guard let identifier: String = recordView.identifier?.rawValue else { return }
        recordView.keyCombo = self.userDefaults.keyCombo(forKey: identifier)
    }

}
