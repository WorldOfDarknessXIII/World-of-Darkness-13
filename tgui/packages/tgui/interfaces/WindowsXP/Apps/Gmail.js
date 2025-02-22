import gmail_icon from '../../../assets/WindowsXP/gmail.png';
import { Icon, Input, TextArea } from '../../../components';
import { useLocalState } from '../../../backend';
import { XPButton } from '../Components';

export const Gmail = props => {
  const { app, act } = props;
  return (
    <div className="gmail">
      <div className="header">
        <div className="nav-link active-link">Gmail</div>
        <div className="header-link">{app.email_adress}</div>
      </div>
      <div className="search-header">
        <div className="gmail-icon">
          <img src={gmail_icon} />
        </div>
        <Input className="search-input" />
        <XPButton content="Search Mail" />
      </div>
      <div className="main-body">
        <div className="mail-nav-panel">
          <div
            className={
              'nav-link' + (app.screen === 0 ? ' active-nav-link' : '')
            }
            onClick={() => act('gmail_switch_screen', { screen: 0 })}>
            Compose Mail
          </div>
          <div className="sidebar-links">
            <div
              className={
                'nav-link' + (app.screen === 1 ? ' active-nav-link' : '')
              }
              onClick={() => act('gmail_switch_screen', { screen: 1 })}>
              {'Inbox (' + app.emails.length + ')'}
            </div>
            <div
              className={
                'nav-link' + (app.screen === 2 ? ' active-nav-link' : '')
              }
              onClick={() => act('gmail_switch_screen', { screen: 2 })}>
              Stared <Icon name="star" style={{ color: '#ff9f29' }} />
            </div>
            <div className="nav-link">Chats</div>
            <div className="nav-link">Sent Mail</div>
            <div className="nav-link">All Mail</div>
            <div className="nav-link">Trash</div>
          </div>
        </div>
        <div className="gmail-body">
          {app.screen === 0 && <ComposeEmail act={act} />}
          {app.screen === 1 && <Emails emails={app.emails} act={act} />}
          {app.screen === 2 && <Stared emails={app.emails} act={act} />}
          {app.screen === 4 && (
            <EmailScreen email={app.current_email} act={act} />
          )}
        </div>
      </div>
    </div>
  );
};

const Emails = props => {
  const { emails, act } = props;
  return (
    <>
      <div className="mails-title">Welcome to the Gmail!</div>
      <EmailActions act={act} />
      <div className="messages">
        {emails.map(email => {
          return <Email key={email.reference} email={email} act={act} />;
        })}
      </div>
      <EmailActions act={act} />
    </>
  );
};

const Stared = props => {
  const { emails, act } = props;
  return (
    <>
      <div className="mails-title">Welcome to the Gmail!</div>
      <EmailActions act={act} />
      <div className="messages">
        {emails.map(email => {
          return email.stared === 1 && <Email email={email} act={act} />;
        })}
      </div>
      <EmailActions act={act} />
    </>
  );
};

const ComposeEmail = (props, context) => {
  const { act } = props;
  const [to, setTo] = useLocalState(context, 'gmail_to', '');
  const [subject, setSubject] = useLocalState(context, 'gmail_subject', '');
  const [message, setMessage] = useLocalState(context, 'gmail_message', '');
  return (
    <div className="compose">
      <ComposerActions
        act={act}
        to={to}
        subject={subject}
        message={message}
        setTo={setTo}
        setMessage={setMessage}
        setSubject={setSubject}
      />
      <div className="compose-body">
        <div className="compose-info">
          <div className="compose-reciever">
            <div className="reciever-info">To:</div>
            <Input
              onInput={(e, value) => {
                setTo(value);
              }}
              value={to}
              className="reciever-input reciever-to"
            />
          </div>
          <div className="compose-reciever">
            <div className="reciever-info">Subject:</div>
            <TextArea
              onInput={(e, value) => {
                setSubject(value);
              }}
              value={subject}
              className="reciever-input"
            />
          </div>
        </div>
        <TextArea
          onInput={(e, value) => {
            setMessage(value);
          }}
          value={message}
          className="compose-mail"
        />
        <ComposerActions
          act={act}
          to={to}
          subject={subject}
          message={message}
          setTo={setTo}
          setMessage={setMessage}
          setSubject={setSubject}
        />
      </div>
    </div>
  );
};

const ComposerActions = props => {
  const { act, to, message, subject, setTo, setMessage, setSubject } = props;
  return (
    <div className="compose-header">
      <XPButton
        content="Send"
        onClick={() => {
          act('gmail_send_email', {
            to: to,
            subject: subject,
            message: message,
          });
          setTo('');
          setMessage('');
          setSubject('');
        }}
      />
      <XPButton
        content="Discard"
        onClick={() => act('gmail_switch_screen', { screen: 1 })}
      />
    </div>
  );
};

const Email = props => {
  const { email, act } = props;
  return (
    <div
      className="email"
      onDoubleClick={() => {
        act('set_current_email', { ref: email.reference });
        act('gmail_switch_screen', { screen: 4 });
      }}>
      <div className="email-buttons">
        <input
          type="checkbox"
          checked={email.checked === 1}
          onClick={() => {
            act('set_email_check', { ref: email.reference });
          }}
        />
        <Icon
          name="star"
          className="star"
          onClick={() => {
            act('set_email_star', { ref: email.reference });
          }}
          style={email.stared && { color: '#ff9f29' }}
        />
      </div>
      <div className="text-block">
        {email.sender.length > 13
          ? email.sender.substring(0, 10) + '...'
          : email.sender}
      </div>
      <div className="text-block email-message">
        {email.message.length > 11
          ? email.message.substring(0, 8) + '...'
          : email.message}
      </div>
      <div className="text-block date">{email.date}</div>
    </div>
  );
};
const EmailActions = props => {
  const { act } = props;
  return (
    <div className="mail-actions">
      <div className="actions basic">
        <XPButton content="Archive" />
        <XPButton content="Report Spam" />
        <XPButton content="Delete" onClick={() => act('delete_emails')} />
        <div className="action-link">Refresh</div>
        <p />
      </div>
      <div className="actions">
        <div style={{ display: 'inline-block' }}>Select:</div>
        <div
          className="action-link"
          onClick={() => {
            act('select_all_emails');
          }}>
          All,{' '}
        </div>
        <div
          className="action-link"
          onClick={() => {
            act('deselect_all_emails');
          }}>
          None
        </div>
      </div>
    </div>
  );
};

const EmailScreen = props => {
  const { email, act } = props;
  return (
    <>
      <div className="mails-title">Your advertisement could be here</div>
      <div className="message-actions">
        <div
          className="back-to-inbox"
          onClick={() => act('gmail_switch_screen', { screen: 1 })}>
          « Back to inbox
        </div>
      </div>
      <div className="message">
        <div className="message-title">
          <b>{email.subject}</b>
        </div>
        <div className="message-body">
          <div className="message-header">
            <div>
              from: <b>{email.sender}</b>
              <XPButton
                content="Delete"
                onClick={() => act('delete_email', { ref: email.reference })}
              />
            </div>
            <div>{email.date}</div>
          </div>
          <div className="message-block">{email.message}</div>
        </div>
      </div>
    </>
  );
};
