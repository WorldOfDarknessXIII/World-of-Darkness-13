import { HeaderButtons } from './Windows/HeaderButtons';
import logo from '../../assets/WindowsXP/login-xp.jpg';
import { XPButton, XPInput } from './Components';
import { useLocalState } from '../../backend';

export const LoginScreen = (props, context) => {
  const { data, act } = props;
  const [name, setName] = useLocalState(context, "login_username", "");
  const [password, setPassword] = useLocalState(context, "login_pass", "");

  return (
    <div className="login-screen">
      <div
        className={'window'}
        style={{
          width: '450px',
          height: '240px',
          left: '400px',
          top: '200px',
          display: 'flex',
          background: '#0831d9',
        }}>
        <div
          className={'header__bg'}
          style={{
            background:
              'linear-gradient(to bottom,#0058ee 0%,#3593ff 4%,#288eff 6%,#127dff 8%,#036ffc 10%,#0262ee 14%,#0057e5 20%,#0054e3 24%,#0055eb 56%,#005bf5 66%,#026afe 76%,#0062ef 86%,#0052d6 92%,#0040ab 94%,#003092 100%)',
          }}
        />
        <header className="app__header">
          <div className="app__header__title">Log On to Windows</div>
          <HeaderButtons is_Focus />
        </header>
        <div className="app__content">
          <div className="login-background">
            <div className="login-header">
              <div className="login-logobar">
                <div className="login-copy">
                  Copyright ©1985-2004
                  <br />
                  Microsoft Corporacion
                </div>
                <div className="login-logo">
                  <img width="100%" src={logo} alt="windows-logo" />
                </div>
                <div className="login-corp">Microsoft</div>
              </div>
              <div className="login-bar" />
            </div>
            <div className="login-footer">
              <div className="login-row">
                <div>User name:</div>
                <XPInput
                  value={name}
                  onInput={(e, value) => setName(value)}
                />
              </div>
              <div className="login-row">
                <div>Password:</div>
                <XPInput
                  value={password}
                  onInput={(e, value) => setPassword(value)} />
              </div>
              <div className="login-buttons">
                <XPButton content="OK"
                  onClick={() => act("login", { password: password, username: name })} />
                <XPButton content="Cancel" disabled />
                <XPButton content="Shut Down..." disabled />
                <XPButton content="Options <<" disabled />
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};
