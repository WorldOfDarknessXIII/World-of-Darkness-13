import { useBackend, useLocalState } from "../backend";
import {
  Button,
  Stack,
  Input,
  Section,
  Tabs,
  Box,
  NoticeBox,
} from "../components";
import { Window } from "../layouts";

export const BaaliRune = (props, context) => {
  const { act, data } = useBackend(context);
  const { corpses, rituals, categories } = data;
  const [searchText, setSearchText] = useLocalState(context, "runeSearch", "");
  const [selectedCategory, setSelectedCategory] = useLocalState(
    context,
    "runeCategory",
    categories.length > 0 ? categories[0] : ""
  );
  let findedRituals = rituals.filter((value) => {
    if (searchText.length === 0) {
      return value.category === selectedCategory;
    }
    return value.name.toLowerCase().includes(searchText.toLowerCase());
  });
  return (
    <Window theme="baali" width={800} height={666}>
      <Window.Content>
        <Stack fill>
          <Stack.Item width="160px">
            <Stack vertical fill>
              <Stack.Item>
                <Button
                  bold
                  fluid
                  color="black"
                  lineHeight={2}

                  style={{
                    overflow: "hidden",
                    whiteSpace: "nowrap",
                    textOverflow: "ellipsis",
                    textAlign: "center",
                  }}
                >
                  {stringifyCorpsesCount(corpses)}
                </Button>
              </Stack.Item>
              <Stack.Item>
                <Button
                  bold
                  fluid
                  color="bad"
                  lineHeight={2}
                  content="Sacrifice"
                  style={{
                    overflow: "hidden",
                    whiteSpace: "nowrap",
                    textOverflow: "ellipsis",
                    textAlign: "center",
                  }}
                  onClick={() => act("sacrifice")}
                />
              </Stack.Item>
              <Stack.Item>
                <Input
                  autoFocus
                  value={searchText}
                  placeholder="Search..."
                  onInput={(e, value) => setSearchText(value)}
                  fluid
                />
              </Stack.Item>
              <Stack.Item>
                <Section>
                  <Tabs vertical fill>
                    {categories.map((category) => (
                      <Tabs.Tab
                        py={0.8}
                        key={category}
                        selected={category == selectedCategory}
                        onClick={() => setSelectedCategory(category)}
                      >
                        {category}
                      </Tabs.Tab>
                    ))}
                  </Tabs>
                </Section>
              </Stack.Item>
            </Stack>
          </Stack.Item>
          <Stack vertical width="100%">
            <Box pl={1} style={{ overflowY: "auto" }}>
              {findedRituals.length === 0 && (
                <NoticeBox>
                  {searchText.length === 0
                    ? "No rituals in this category."
                    : "No rituals found."}
                </NoticeBox>
              )}
              {findedRituals.map((value) => (
                <ItemBox item={value} />
              ))}
            </Box>
          </Stack>
        </Stack>
      </Window.Content>
    </Window>
  );
};

const ItemBox = (props, context) => {
  const { act } = useBackend(context);
  const { item } = props;
  return (
    <Section
      title={item.name}
      buttons={[
        <Button
          content={stringifyCorpsesCount(item.cost)}
          onClick={() =>
            act("ritual", { category: item.category, name: item.name })
          }
        />,
      ]}
    >
      {item.description}
    </Section>
  );
};

function stringifyCorpsesCount(count) {
  return count == 1 ? count + " corpse" : count + " corpses";
}
