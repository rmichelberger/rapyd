

function dateString(date: Date): string {
  const day = date.getDate();

  const month = date.getMonth() + 1;
  const yyyy = date.getFullYear();
  let dd;
  if (day < 10) {
    dd = "0" + day;
  } else {
    dd = day;
  }
  let mm;
  if (month < 10) {
    mm = "0" + month;
  } else {
    mm = month;
  }
  return mm + "/" + dd + "/" + yyyy;
}
export {dateString};
