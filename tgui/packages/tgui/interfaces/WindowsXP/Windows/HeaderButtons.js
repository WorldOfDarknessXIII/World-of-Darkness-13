export const HeaderButtons = (props) => {
  const {
    is_Focus,
    maximize,
    minimize,
    close,
    resizable,
    on_close,
    on_minimize,
    on_maximize,
  } = props;

  return (
    <div className="header__buttons">
      {minimize && (
        <div
          onClick={() => {
            on_minimize();
          }}
          key="minimize"
          className="header__button header__button--minimize"
          style={{ opacity: is_Focus ? 1 : 0.7 }}
        />
      )}
      {maximize && (
        <div
          onClick={() => {
            on_maximize();
          }}
          key="maximize"
          className={`header__button ${'header__button--maximize'} ${resizable ? '' : 'header__button--disable'}`}
          style={{ opacity: is_Focus ? 1 : 0.7 }}
        />
      )}
      {close && (
        <div
          onClick={() => {
            on_close();
          }}
          key="button"
          className="header__button header__button--close"
          style={{ opacity: is_Focus ? 1 : 0.7 }}
        />
      )}
    </div>
  );
};
